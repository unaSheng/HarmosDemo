import { common, OpenLinkOptions, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { UIContext } from '@kit.ArkUI';

const BAIDU_MAP_SCHEME: string = 'baidumap://';
const BAIDU_MAP_SRC: string = 'harmony.una.simpledemo';

function buildBaiduMapMarkerLink(latitude: number, longitude: number): string {
  const location = `${latitude},${longitude}`;
  const title = encodeURIComponent('我的位置');
  const content = encodeURIComponent(
    `纬度 ${latitude.toFixed(6)}, 经度 ${longitude.toFixed(6)}`);
  return `${BAIDU_MAP_SCHEME}map/marker?location=${location}` +
    `&title=${title}&content=${content}&coord_type=wgs84&src=${BAIDU_MAP_SRC}`;
}

export async function openBaiduMapWithLocation(
  uiContext: UIContext,
  latitude: number,
  longitude: number,
): Promise<boolean> {
  const context = uiContext.getHostContext() as common.UIAbilityContext;
  const link = buildBaiduMapMarkerLink(latitude, longitude);
  const want: Want = { uri: link };

  try {
    await context.startAbility(want);
    return true;
  } catch (startErr) {
    const startError = startErr as BusinessError;
    console.error(`startAbility Baidu Map failed, code=${startError.code}, message=${startError.message}`);
  }

  try {
    const options: OpenLinkOptions = {
      appLinkingOnly: false,
    };
    await context.openLink(link, options);
    return true;
  } catch (openErr) {
    const openError = openErr as BusinessError;
    console.error(`openLink Baidu Map failed, code=${openError.code}, message=${openError.message}`);
    return false;
  }
}
