import { bundleManager, common, OpenLinkOptions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { UIContext } from '@kit.ArkUI';

const WECHAT_LINK: string = 'weixin://';

export function openWeChat(uiContext: UIContext): void {
  const context = uiContext.getHostContext() as common.UIAbilityContext;
  try {
    const canOpen: boolean = bundleManager.canOpenLink(WECHAT_LINK);
    if (!canOpen) {
      console.error('WeChat is not installed');
      return;
    }
    const options: OpenLinkOptions = {
      appLinkingOnly: false,
    };
    context.openLink(WECHAT_LINK, options).catch((err: BusinessError) => {
      console.error(`openWeChat failed, code=${err.code}, message=${err.message}`);
    });
  } catch (err) {
    const error = err as BusinessError;
    console.error(`openWeChat failed, code=${error.code}, message=${error.message}`);
  }
}
