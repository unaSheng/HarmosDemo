import { BusinessError } from '@kit.BasicServicesKit';
import { http } from '@kit.NetworkKit';
import { UserInfo, UserInfoRecord } from '../model/UserInfo';
import { SupabaseConfig } from './SupabaseConfig';

function buildHeaders(): Record<string, string> {
  return {
    'Authorization': `Bearer ${SupabaseConfig.ANON_KEY}`,
    'apikey': SupabaseConfig.ANON_KEY,
    'Content-Type': 'application/json',
  };
}

export async function insertUserInfo(user: UserInfo): Promise<UserInfo | undefined> {
  const url = `${SupabaseConfig.PROJECT_URL}/rest/v1/user_info`;
  const httpRequest = http.createHttp();
  try {
    const response = await httpRequest.request(url, {
      method: http.RequestMethod.POST,
      header: {
        'Authorization': `Bearer ${SupabaseConfig.ANON_KEY}`,
        'apikey': SupabaseConfig.ANON_KEY,
        'Content-Type': 'application/json',
        'Prefer': 'return=representation',
      },
      extraData: JSON.stringify(user.toInsertRecord()),
      connectTimeout: 60000,
      readTimeout: 60000,
    });
    if (response.responseCode !== 201 && response.responseCode !== 200) {
      console.error(`insertUserInfo failed, code=${response.responseCode}, body=${response.result}`);
      return undefined;
    }
    const records = JSON.parse(response.result as string) as UserInfoRecord[];
    if (records.length === 0) {
      return undefined;
    }
    return UserInfo.fromRecord(records[0]);
  } catch (err) {
    const error = err as BusinessError;
    console.error(`insertUserInfo failed, code=${error.code}, message=${error.message}`);
    return undefined;
  } finally {
    httpRequest.destroy();
  }
}

export async function updateUserInfo(user: UserInfo): Promise<UserInfo | undefined> {
  const url = `${SupabaseConfig.PROJECT_URL}/rest/v1/user_info?id=eq.${user.id}`;
  const httpRequest = http.createHttp();
  try {
    const response = await httpRequest.request(url, {
      method: http.RequestMethod.PUT,
      header: {
        'Authorization': `Bearer ${SupabaseConfig.ANON_KEY}`,
        'apikey': SupabaseConfig.ANON_KEY,
        'Content-Type': 'application/json',
        'Prefer': 'return=representation',
      },
      extraData: JSON.stringify(user.toInsertRecord()),
      connectTimeout: 60000,
      readTimeout: 60000,
    });
    if (response.responseCode !== 200) {
      console.error(`updateUserInfo failed, code=${response.responseCode}, body=${response.result}`);
      return undefined;
    }
    const records = JSON.parse(response.result as string) as UserInfoRecord[];
    if (records.length === 0) {
      return undefined;
    }
    return UserInfo.fromRecord(records[0]);
  } catch (err) {
    const error = err as BusinessError;
    console.error(`updateUserInfo failed, code=${error.code}, message=${error.message}`);
    return undefined;
  } finally {
    httpRequest.destroy();
  }
}

export async function fetchUserInfoList(): Promise<UserInfo[]> {
  const url =
    `${SupabaseConfig.PROJECT_URL}/rest/v1/user_info?select=*&order=created_at.desc`;
  const httpRequest = http.createHttp();
  try {
    const response = await httpRequest.request(url, {
      method: http.RequestMethod.GET,
      header: buildHeaders(),
      connectTimeout: 60000,
      readTimeout: 60000,
    });
    if (response.responseCode !== 200) {
      console.error(`fetchUserInfoList failed, code=${response.responseCode}, body=${response.result}`);
      return [];
    }
    const records = JSON.parse(response.result as string) as UserInfoRecord[];
    const users: UserInfo[] = [];
    records.forEach((record: UserInfoRecord) => {
      users.push(UserInfo.fromRecord(record));
    });
    return users;
  } catch (err) {
    const error = err as BusinessError;
    console.error(`fetchUserInfoList failed, code=${error.code}, message=${error.message}`);
    return [];
  } finally {
    httpRequest.destroy();
  }
}
