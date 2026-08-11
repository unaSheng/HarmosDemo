if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
import router from "@ohos:router";
import { Info } from "@normalized:N&&&entry/src/main/ets/model/Info&";
class HorizontalListPage extends ViewV2 {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda, extraInfo) {
        super(parent, elmtId, extraInfo);
        this.items = ['列表页 1', '列表页 2', '列表页 3', '列表页 4'];
        this.info = new Info();
        this.finalizeConstruction();
    }
    public resetStateVarsOnReuse(params: Object): void {
        this.info = new Info();
    }
    private readonly items: string[];
    @Local
    info: Info;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Scroll.create();
            Scroll.width('100%');
            Scroll.height('100%');
            Scroll.scrollBar(BarState.Auto);
        }, Scroll);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
            Row.padding({
                left: 12,
                right: 12,
                top: 12,
                bottom: 12
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel({ "id": 16777222, "type": 10003, params: [], "bundleName": "com.example.simpledemo", "moduleName": "entry" });
            Button.type(ButtonType.Normal);
            Button.backgroundColor(Color.Transparent);
            Button.fontColor('#007DFF');
            Button.onClick(() => {
                router.back();
            });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777224, "type": 10003, params: [], "bundleName": "com.example.simpledemo", "moduleName": "entry" });
            Text.fontSize(18);
            Text.fontWeight(FontWeight.Medium);
            Text.layoutWeight(1);
            Text.textAlign(TextAlign.Center);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.width(48);
        }, Blank);
        Blank.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`name: ${this.info.name}, age: ${this.info.age}`);
            Text.fontSize(16);
            Text.margin({ bottom: 8 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('反序列化');
            Button.margin({ bottom: 8 });
            Button.onClick(() => {
                // const realInfo: Info = new Info();
                // realInfo.name = 'Alice';
                // realInfo.age = 30;
                // const jsonResult: string = JSON.stringify(realInfo);
                // const restoredInfo: Info = Info.fromJSON(jsonResult);
                // const isInfoByRestored: boolean = restoredInfo instanceof Info;
                // this.info.name = restoredInfo.name;
                // this.info.age = restoredInfo.age;
                // console.log(`${isInfoByRestored}`);
                router.pushUrl({ url: 'pages/DetailPage', params: this.info }).catch(() => {
                });
            });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('age + 1（验证 @Trace 响应式）');
            Button.margin({ bottom: 16 });
            Button.onClick(() => {
                this.info.age++;
            });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Swiper.create();
            Swiper.width('100%');
            Swiper.height(320);
            Swiper.indicator(true);
            Swiper.loop(false);
        }, Swiper);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = (_item, index: number) => {
                const item = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.width('100%');
                    Column.height('100%');
                    Column.justifyContent(FlexAlign.Center);
                    Column.backgroundColor(index % 2 === 0 ? '#F5F7FA' : '#EEF2F7');
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(item);
                    Text.fontSize(28);
                    Text.fontWeight(FontWeight.Bold);
                }, Text);
                Text.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(`第 ${index + 1} 页 / 共 ${this.items.length} 页`);
                    Text.fontSize(14);
                    Text.fontColor('#666666');
                    Text.margin({ top: 12 });
                }, Text);
                Text.pop();
                Column.pop();
            };
            this.forEachUpdateFunction(elmtId, this.items, forEachItemGenFunction, (item: string, index: number) => `${index}_${item}`, true, true);
        }, ForEach);
        ForEach.pop();
        Swiper.pop();
        Column.pop();
        Scroll.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "HorizontalListPage";
    }
}
registerNamedRoute(() => new HorizontalListPage(undefined, {}), "", { bundleName: "com.example.simpledemo", moduleName: "entry", pagePath: "pages/HorizontalListPage", pageFullPath: "entry/src/main/ets/pages/HorizontalListPage", integratedHsp: "false", moduleType: "followWithHap" });
