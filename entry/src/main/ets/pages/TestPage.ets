import { BusinessError } from '@kit.BasicServicesKit';
import { taskpool } from '@kit.ArkTS';

@Concurrent
function testPromise(args1: number, args2: number): Promise<number> {
  return new Promise<number>((resolve) => {
    resolve(args1 + args2);
  });
}

@Concurrent
async function testPromise1(args1: number, args2: number): Promise<number> {
  return new Promise<number>((resolve) => {
    resolve(args1 + args2);
  });
}

@Concurrent
async function testPromise2(args1: number, args2: number): Promise<number> {
  return await new Promise<number>((resolve) => {
    resolve(args1 + args2);
  });
}

@Concurrent
function testPromise3() {
  return Promise.resolve(1);
}

@Concurrent
async function testPromise4(): Promise<number> {
  return 1;
}

@Concurrent
async function testPromise5(): Promise<string> {
  return await new Promise((resolve) => {
    setTimeout(() => {
      resolve('Promise setTimeout after resolve');
    }, 1000);
  });
}

async function testConcurrentFunc(): Promise<void> {
  const task1: taskpool.Task = new taskpool.Task(testPromise, 1, 2);
  const task2: taskpool.Task = new taskpool.Task(testPromise1, 1, 2);
  const task3: taskpool.Task = new taskpool.Task(testPromise2, 1, 2);
  const task4: taskpool.Task = new taskpool.Task(testPromise3);
  const task5: taskpool.Task = new taskpool.Task(testPromise4);
  const task6: taskpool.Task = new taskpool.Task(testPromise5);

  taskpool.execute(task1).then((d: object) => {
    console.info(`=== lwx === task1 res is: ${d}`);
  }).catch((e: BusinessError) => {
    console.error(`=== lwx === task1 catch e: ${e}`);
  });
  taskpool.execute(task2).then((d: object) => {
    console.info(`=== lwx === task2 res is: ${d}`);
  }).catch((e: BusinessError) => {
    console.error(`=== lwx === task2 catch e: ${e}`);
  });
  taskpool.execute(task3).then((d: object) => {
    console.info(`=== lwx === task3 res is: ${d}`);
  }).catch((e: BusinessError) => {
    console.error(`=== lwx === task3 catch e: ${e}`);
  });
  taskpool.execute(task4).then((d: object) => {
    console.info(`=== lwx === task4 res is: ${d}`);
  }).catch((e: BusinessError) => {
    console.error(`=== lwx === task4 catch e: ${e}`);
  });
  taskpool.execute(task5).then((d: object) => {
    console.info(`=== lwx === task5 res is: ${d}`);
  }).catch((e: BusinessError) => {
    console.error(`=== lwx === task5 catch e: ${e}`);
  });
  taskpool.execute(task6).then((d: object) => {
    console.info(`=== lwx === task6 res is: ${d}`);
  }).catch((e: BusinessError) => {
    console.error(`=== lwx === task6 catch e: ${e}`);
  });
}

@ComponentV2
export struct TestPage {
  private pathStack?: NavPathStack;
  @Local message: string = 'Hello World';

  build() {
    NavDestination() {
      Column() {
        Column() {
          Button(this.message)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              testConcurrentFunc().then(() => {
                this.message = 'success';
              }).catch((e: BusinessError) => {
                this.message = 'failed';
                console.error(`testConcurrentFunc catch e: ${e}`);
              });
            })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#FFFFFF')
    }
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx.pathStack;
    })
  }
}
