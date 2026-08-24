import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import { http } from '@kit.NetworkKit';
import { notificationManager } from '@kit.NotificationKit';
import { UIContext } from '@kit.ArkUI';

const DELETE_NOTIFICATION_BASE_ID = 10000;
const BANNER_SLOT_TYPE = notificationManager.SlotType.SOCIAL_COMMUNICATION;
const DEFAULT_APP_ICON: Resource = $r('app.media.startIcon');
const PICTURE_SIZE: image.Size = { width: 400, height: 200 };
const BANNER_ICON_SIZE: image.Size = { width: 128, height: 128 };

function calculateCenterCropRegion(
  sourceWidth: number,
  sourceHeight: number,
  targetWidth: number,
  targetHeight: number,
): image.Region {
  const targetRatio = targetWidth / targetHeight;
  const sourceRatio = sourceWidth / sourceHeight;
  let cropWidth = sourceWidth;
  let cropHeight = sourceHeight;
  if (sourceRatio > targetRatio) {
    cropWidth = Math.floor(sourceHeight * targetRatio);
  } else if (sourceRatio < targetRatio) {
    cropHeight = Math.floor(sourceWidth / targetRatio);
  }
  return {
    x: Math.floor((sourceWidth - cropWidth) / 2),
    y: Math.floor((sourceHeight - cropHeight) / 2),
    size: { width: cropWidth, height: cropHeight },
  };
}

async function createFittedPixelMap(
  imageSource: image.ImageSource,
  targetSize: image.Size,
): Promise<image.PixelMap | undefined> {
  let pixelMap: image.PixelMap | undefined = undefined;
  try {
    pixelMap = await imageSource.createPixelMap({ editable: true });
    const imageInfo = await pixelMap.getImageInfo();
    const region = calculateCenterCropRegion(
      imageInfo.size.width,
      imageInfo.size.height,
      targetSize.width,
      targetSize.height,
    );
    await pixelMap.crop(region);
    const croppedInfo = await pixelMap.getImageInfo();
    if (croppedInfo.size.width <= 0 || croppedInfo.size.height <= 0) {
      return pixelMap;
    }
    const scaleX = targetSize.width / croppedInfo.size.width;
    const scaleY = targetSize.height / croppedInfo.size.height;
    await pixelMap.scale(scaleX, scaleY);
    return pixelMap;
  } catch (err) {
    pixelMap?.release();
    const error = err as BusinessError;
    console.error(`createFittedPixelMap failed, code=${error.code}, message=${error.message}`);
    return undefined;
  }
}

async function ensureNotificationEnabled(context: common.UIAbilityContext): Promise<boolean> {
  try {
    const enabled = await notificationManager.isNotificationEnabled();
    if (enabled) {
      return true;
    }
    await notificationManager.requestEnableNotification(context);
    return await notificationManager.isNotificationEnabled();
  } catch (err) {
    const error = err as BusinessError;
    console.error(`ensureNotificationEnabled failed, code=${error.code}, message=${error.message}`);
    return false;
  }
}

async function ensureBannerNotificationSlot(): Promise<void> {
  try {
    // 公共 API 仅支持 SlotType；SOCIAL_COMMUNICATION 默认对应 LEVEL_HIGH（横幅 + 提示音）
    await notificationManager.addSlot(BANNER_SLOT_TYPE);
  } catch (err) {
    const error = err as BusinessError;
    console.error(`ensureBannerNotificationSlot failed, code=${error.code}, message=${error.message}`);
  }
}

async function loadPixelMapFromResource(
  context: common.UIAbilityContext,
  resource: Resource,
  size: image.Size,
): Promise<image.PixelMap | undefined> {
  let imageSource: image.ImageSource | undefined = undefined;
  try {
    const fileData = await context.resourceManager.getMediaContent(resource);
    imageSource = image.createImageSource(fileData.buffer);
    return await createFittedPixelMap(imageSource, size);
  } catch (err) {
    const error = err as BusinessError;
    console.error(`loadPixelMapFromResource failed, code=${error.code}, message=${error.message}`);
    return undefined;
  } finally {
    imageSource?.release();
  }
}

async function loadPixelMapFromUrl(url: string, size: image.Size): Promise<image.PixelMap | undefined> {
  const httpRequest = http.createHttp();
  let imageSource: image.ImageSource | undefined = undefined;
  try {
    const response = await httpRequest.request(url, {
      method: http.RequestMethod.GET,
      expectDataType: http.HttpDataType.ARRAY_BUFFER,
      connectTimeout: 60000,
      readTimeout: 60000,
    });
    if (response.responseCode !== 200 || !response.result) {
      console.error(`loadPixelMapFromUrl failed, code=${response.responseCode}`);
      return undefined;
    }
    imageSource = image.createImageSource(response.result as ArrayBuffer);
    return await createFittedPixelMap(imageSource, size);
  } catch (err) {
    const error = err as BusinessError;
    console.error(`loadPixelMapFromUrl failed, code=${error.code}, message=${error.message}`);
    return undefined;
  } finally {
    imageSource?.release();
    httpRequest.destroy();
  }
}

async function resolveNotificationPicture(
  context: common.UIAbilityContext,
  avatarUrl: string,
): Promise<image.PixelMap | undefined> {
  if (avatarUrl.length > 0) {
    const avatarPixelMap = await loadPixelMapFromUrl(avatarUrl, PICTURE_SIZE);
    if (avatarPixelMap) {
      return avatarPixelMap;
    }
  }
  return loadPixelMapFromResource(context, DEFAULT_APP_ICON, PICTURE_SIZE);
}

async function resolveBannerLargeIcon(
  context: common.UIAbilityContext,
  avatarUrl: string,
): Promise<image.PixelMap | undefined> {
  if (avatarUrl.length > 0) {
    const avatarIcon = await loadPixelMapFromUrl(avatarUrl, BANNER_ICON_SIZE);
    if (avatarIcon) {
      return avatarIcon;
    }
  }
  return loadPixelMapFromResource(context, DEFAULT_APP_ICON, BANNER_ICON_SIZE);
}

export async function publishUserDeletedNotification(
  uiContext: UIContext,
  userId: number,
  nickname: string,
  avatarUrl: string,
): Promise<void> {
  const context = uiContext.getHostContext() as common.UIAbilityContext;
  const enabled = await ensureNotificationEnabled(context);
  if (!enabled) {
    console.error('publishUserDeletedNotification skipped: notification not enabled');
    return;
  }

  await ensureBannerNotificationSlot();

  const title = nickname.trim();
  const picturePixelMap = await resolveNotificationPicture(context, avatarUrl);
  const largeIconPixelMap = await resolveBannerLargeIcon(context, avatarUrl);
  if (!picturePixelMap) {
    console.error('publishUserDeletedNotification skipped: picture unavailable');
    largeIconPixelMap?.release();
    return;
  }

  const notificationRequest: notificationManager.NotificationRequest = {
    id: DELETE_NOTIFICATION_BASE_ID + userId,
    notificationSlotType: BANNER_SLOT_TYPE,
    showDeliveryTime: true,
    largeIcon: largeIconPixelMap,
    content: {
      notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_PICTURE,
      picture: {
        title,
        text: '已被删除',
        briefText: '已被删除',
        expandedTitle: title,
        picture: picturePixelMap,
      },
    },
  };

  try {
    await notificationManager.publish(notificationRequest);
  } catch (err) {
    const error = err as BusinessError;
    console.error(`publishUserDeletedNotification failed, code=${error.code}, message=${error.message}`);
  } finally {
    picturePixelMap.release();
    largeIconPixelMap?.release();
  }
}
