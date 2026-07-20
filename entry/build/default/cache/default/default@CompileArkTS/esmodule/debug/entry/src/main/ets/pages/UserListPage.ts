if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface UserListPage_Params {
    users?: UserInfo[];
}
import router from "@ohos:router";
interface UserInfo {
    id: number;
    name: string;
    desc: string;
}
class UserListPage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.users = [
            { id: 1, name: '张三', desc: 'HarmonyOS 开发者' },
            { id: 2, name: '李四', desc: 'UI 设计师' },
            { id: 3, name: '王五', desc: '产品经理' },
            { id: 4, name: '赵六', desc: '测试工程师' },
            { id: 5, name: '钱七', desc: '架构师' },
            { id: 6, name: '孙八', desc: '运维工程师' },
            { id: 7, name: '李硕', desc: 'HarmonyOS 开发者' },
            { id: 8, name: '张飒', desc: 'UI 设计师' },
            { id: 9, name: '王鑫', desc: '产品经理' },
            { id: 10, name: '赵丽', desc: '测试工程师' },
            { id: 11, name: '钱律', desc: '架构师' },
            { id: 12, name: '苏娜', desc: '运维工程师' },
        ];
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: UserListPage_Params) {
        if (params.users !== undefined) {
            this.users = params.users;
        }
    }
    updateStateVars(params: UserListPage_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private readonly users: UserInfo[];
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
            Text.create({ "id": 16777231, "type": 10003, params: [], "bundleName": "com.example.simpledemo", "moduleName": "entry" });
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
            List.create();
            List.width('100%');
            List.layoutWeight(1);
            List.divider({ strokeWidth: 1, color: '#EEEEEE' });
        }, List);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const user = _item;
                {
                    const itemCreation = (elmtId, isInitialRender) => {
                        ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                        ListItem.create(deepRenderFunction, true);
                        if (!isInitialRender) {
                            ListItem.pop();
                        }
                        ViewStackProcessor.StopGetAccessRecording();
                    };
                    const itemCreation2 = (elmtId, isInitialRender) => {
                        ListItem.create(deepRenderFunction, true);
                    };
                    const deepRenderFunction = (elmtId, isInitialRender) => {
                        itemCreation(elmtId, isInitialRender);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Row.create();
                            Row.width('100%');
                            Row.padding({ left: 16, right: 16, top: 14, bottom: 14 });
                        }, Row);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Column.create();
                            Column.alignItems(HorizontalAlign.Start);
                        }, Column);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Text.create(user.name);
                            Text.fontSize(16);
                            Text.fontWeight(FontWeight.Medium);
                        }, Text);
                        Text.pop();
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Text.create(user.desc);
                            Text.fontSize(13);
                            Text.fontColor('#666666');
                            Text.margin({ top: 4 });
                        }, Text);
                        Text.pop();
                        Column.pop();
                        Row.pop();
                        ListItem.pop();
                    };
                    this.observeComponentCreation2(itemCreation2, ListItem);
                    ListItem.pop();
                }
            };
            this.forEachUpdateFunction(elmtId, this.users, forEachItemGenFunction, (user: UserInfo) => user.id.toString(), false, false);
        }, ForEach);
        ForEach.pop();
        List.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "UserListPage";
    }
}
registerNamedRoute(() => new UserListPage(undefined, {}), "", { bundleName: "com.example.simpledemo", moduleName: "entry", pagePath: "pages/UserListPage", pageFullPath: "entry/src/main/ets/pages/UserListPage", integratedHsp: "false", moduleType: "followWithHap" });
