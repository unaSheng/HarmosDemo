if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
import { Info } from "@normalized:N&&&entry/src/main/ets/model/Info&";
class Detail extends ViewV2 {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda, extraInfo) {
        super(parent, elmtId, extraInfo);
        this.params = undefined;
        this.finalizeConstruction();
    }
    public resetStateVarsOnReuse(params: Object): void {
        this.params = undefined;
    }
    @Local
    params?: Info;
    aboutToAppear(): void {
        const str: string = JSON.stringify(this.getUIContext().getRouter().getParams());
        this.params = Info.fromJSON(str);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`Detail Page: ${this.params?.name} ${this.params?.age}`);
            Text.fontSize(20);
            Text.margin(10);
            Text.onClick(() => {
                if (this.params) {
                    this.params.age = 85;
                }
            });
        }, Text);
        Text.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Detail";
    }
}
registerNamedRoute(() => new Detail(undefined, {}), "", { bundleName: "com.example.simpledemo", moduleName: "entry", pagePath: "pages/DetailPage", pageFullPath: "entry/src/main/ets/pages/DetailPage", integratedHsp: "false", moduleType: "followWithHap" });
