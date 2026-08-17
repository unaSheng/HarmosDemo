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

export function getNetworkTypeDescription(): string {
  try {
    const netHandle = connection.getDefaultNetSync();
    if (!netHandle || netHandle.netId < 100) {
      return '无网络';
    }

    const netCapability = connection.getNetCapabilitiesSync(netHandle);
    const bearers = netCapability.bearerTypes ?? [];
    const types: string[] = [];
    for (const bearer of bearers) {
      if (bearer === connection.NetBearType.BEARER_WIFI) {
        types.push('WiFi');
      } else if (bearer === connection.NetBearType.BEARER_CELLULAR) {
        types.push('蜂窝数据');
      } else if (bearer === connection.NetBearType.BEARER_ETHERNET) {
        types.push('以太网');
      }
    }
    return types.length > 0 ? types.join('/') : '未知网络';
  } catch (err) {
    const error = err as BusinessError;
    console.error(`getNetworkTypeDescription failed, code=${error.code}, message=${error.message}`);
    return '未知网络';
  }
}
