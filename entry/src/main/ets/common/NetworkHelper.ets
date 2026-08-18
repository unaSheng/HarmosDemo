import { BusinessError } from '@kit.BasicServicesKit';
import { connection } from '@kit.NetworkKit';

export function isNetworkAvailable(): boolean {
  try {
    const netHandle = connection.getDefaultNetSync();
    if (!netHandle || netHandle.netId < 100) {
      return false;
    }

    const netCapability = connection.getNetCapabilitiesSync(netHandle);
    const caps = netCapability.networkCap;
    if (!caps) {
      return false;
    }

    for (const cap of caps) {
      if (cap === connection.NetCap.NET_CAPABILITY_INTERNET ||
        cap === connection.NetCap.NET_CAPABILITY_VALIDATED) {
        return true;
      }
    }
  } catch (err) {
    const error = err as BusinessError;
    console.error(`isNetworkAvailable failed, code=${error.code}, message=${error.message}`);
  }
  return false;
}
