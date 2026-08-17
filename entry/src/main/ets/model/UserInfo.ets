export interface UserInfoRecord {
  id: number;
  avatar_url: string;
  nickname: string;
  age: number;
  signature: string;
  created_at?: string;
}

interface UserInfoInsertRecord {
  avatar_url: string;
  nickname: string;
  age: number;
  signature: string;
}

export class UserInfo {
  id: number = 0;
  avatarUrl: string = '';
  nickname: string = '';
  age: number = 0;
  signature: string = '';

  toInsertRecord(): UserInfoInsertRecord {
    const record: UserInfoInsertRecord = {
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
}
