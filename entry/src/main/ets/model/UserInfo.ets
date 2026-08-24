export interface UserInfoRecord {
  id: number;
  avatar_url: string;
  nickname: string;
  age: number;
  signature: string;
  created_at?: string;
}

export interface UserInfoInsertRecord {
  avatar_url: string;
  nickname: string;
  age: number;
  signature: string;
}

interface UserInfoUpdateRecord extends UserInfoRecord {
  id: number;
}

export interface UserDetailDeleteResult {
  deleted: boolean;
  userId: number;
}

export function isUserDetailDeleteResult(result: Object): boolean {
  const candidate = result as UserDetailDeleteResult;
  return candidate.deleted === true && candidate.userId > 0;
}

@ObservedV2
export class UserInfo {
  @Trace id: number = 0;
  @Trace avatarUrl: string = '';
  @Trace nickname: string = '';
  @Trace age: number = 0;
  @Trace signature: string = '';

  toInsertRecord(): UserInfoInsertRecord {
    const record: UserInfoInsertRecord = {
      avatar_url: this.avatarUrl,
      nickname: this.nickname,
      age: this.age,
      signature: this.signature,
    };
    return record;
  }

  toUpdateRecord(): UserInfoUpdateRecord {
    const record: UserInfoUpdateRecord = {
      id: this.id,
      avatar_url: this.avatarUrl,
      nickname: this.nickname,
      age: this.age,
      signature: this.signature,
    };
    return record;
  }

  static fromRecord(record: UserInfoRecord): UserInfo {
    const user = new UserInfo();
    user.id = record.id;
    user.avatarUrl = record.avatar_url;
    user.nickname = record.nickname;
    user.age = record.age;
    user.signature = record.signature;
    return user;
  }

  static fromPlain(plain: ESObject): UserInfo {
    const user = new UserInfo();
    const idValue: string = plain['id'] ?? plain['__ob_id'];
    const avatarValue: string = plain['avatarUrl'] ?? plain['avatar_url'] ?? plain['__ob_avatarUrl'];
    const nicknameValue: string = plain['nickname'] ?? plain['__ob_nickname'];
    const ageValue: string = plain['age'] ?? plain['__ob_age'];
    const signatureValue: string = plain['signature'] ?? plain['__ob_signature'];

    if (typeof idValue === 'number') {
      user.id = idValue;
    }
    if (typeof avatarValue === 'string') {
      user.avatarUrl = avatarValue;
    }
    if (typeof nicknameValue === 'string') {
      user.nickname = nicknameValue;
    }
    if (typeof ageValue === 'number') {
      user.age = ageValue;
    }
    if (typeof signatureValue === 'string') {
      user.signature = signatureValue;
    }
    return user;
  }
}
