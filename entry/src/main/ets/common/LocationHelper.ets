import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { geoLocationManager } from '@kit.LocationKit';
import { UIContext } from '@kit.ArkUI';

const LOCATION_PERMISSIONS: Permissions[] = [
  'ohos.permission.APPROXIMATELY_LOCATION',
  'ohos.permission.LOCATION',
];

export async function requestLocationPermission(uiContext: UIContext): Promise<boolean> {
  const context = uiContext.getHostContext() as common.UIAbilityContext;
  const atManager = abilityAccessCtrl.createAtManager();
  try {
    const result = await atManager.requestPermissionsFromUser(context, LOCATION_PERMISSIONS);
    return result.authResults.every((status: number) =>
      status === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED);
  } catch (err) {
    const error = err as BusinessError;
    console.error(`requestLocationPermission failed, code=${error.code}, message=${error.message}`);
    return false;
  }
}

export async function getCurrentLocation(): Promise<geoLocationManager.Location | undefined> {
  const requestInfo: geoLocationManager.CurrentLocationRequest = {
    priority: geoLocationManager.LocationRequestPriority.FIRST_FIX,
    scenario: geoLocationManager.LocationRequestScenario.UNSET,
    maxAccuracy: 100,
  };
  try {
    return await geoLocationManager.getCurrentLocation(requestInfo);
  } catch (err) {
    const error = err as BusinessError;
    console.error(`getCurrentLocation failed, code=${error.code}, message=${error.message}`);
    return undefined;
  }
}
