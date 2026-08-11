export interface InfoJSON {
  name: string;
  age: number;
}

@ObservedV2
export class Info {
  @Trace name: string = 'Tom';
  @Trace age: number = 24;

  toJSON(): InfoJSON {
    const result: InfoJSON = {
      name: this.name,
      age: this.age,
    };
    return result;
  }

  static fromJSON(json: string): Info {
    const plain = JSON.parse(json) as InfoJSON;
    const info = new Info();
    info.name = plain.name;
    info.age = plain.age;
    return info;
  }
}
