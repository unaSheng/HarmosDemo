if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface HorizontalListPage_Params {
    items?: string[];
}
import router from "@ohos:router";
class HorizontalListPage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.items = ['列表页 1', '列表页 2', '列表页 3', '列表页 4'];
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: HorizontalListPage_Params) {
        if (params.items !== undefined) {
            this.items = params.items;
        }
    }
    updateStateVars(params: HorizontalListPage_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private readonly items: string[];
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
            Row.padding({ left: 12, right: 12, top: 12, bottom: 12 });
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
            Swiper.create();
            Swiper.width('100%');
            Swiper.layoutWeight(1);
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
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "HorizontalListPage";
    }
}
registerNamedRoute(() => new HorizontalListPage(undefined, {}), "", { bundleName: "com.example.simpledemo", moduleName: "entry", pagePath: "pages/HorizontalListPage", pageFullPath: "entry/src/main/ets/pages/HorizontalListPage", integratedHsp: "false", moduleType: "followWithHap" });
