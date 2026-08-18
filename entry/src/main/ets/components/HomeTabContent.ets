import { AsyncCallback, BusinessError } from '@kit.BasicServicesKit';
import { MapComponent, map, mapCommon } from '@kit.MapKit';
import { openBaiduMapWithLocation } from '../common/BaiduMapLauncher';
import { getCurrentLocation, requestLocationPermission } from '../common/LocationHelper';

@Component
export struct HomeTabContent {
  @State locationText: string = '';
  @State mapStatusText: string = '';
  @State mapReady: boolean = false;
  private mapOptions?: mapCommon.MapOptions;
  private mapCallback?: AsyncCallback<map.MapComponentController>;
  private mapController?: map.MapComponentController;

  aboutToAppear(): void {
    this.mapStatusText = '地图加载中...';
    this.mapOptions = {
      position: {
        target: {
          latitude: 39.9042,
          longitude: 116.4074,
        },
        zoom: 12,
      },
    };
    this.mapCallback = async (err, mapController) => {
      if (err) {
        console.error(`Map init failed, code=${err.code}, message=${err.message}`);
        this.mapStatusText = `地图加载失败(${err.code})，请检查 Map Kit 配置`;
        return;
      }
      this.mapController = mapController;
      mapController.setMyLocationEnabled(true);
      mapController.getEventManager()?.on('mapLoad', () => {
        this.mapReady = true;
        this.mapStatusText = '';
        const markerOptions: mapCommon.MarkerOptions = {
          position: {
            latitude: 39.9042,
            longitude: 116.4074,
          },
          title: '天安门',
        };
        this.mapController?.addMarker(markerOptions).catch((markerErr: BusinessError) => {
          console.error(`addMarker failed, code=${markerErr.code}, message=${markerErr.message}`);
        });
      });
    };

    requestLocationPermission(this.getUIContext()).then((granted: boolean) => {
      if (!granted) {
        this.locationText = '定位权限未授予，蓝点定位可能不可用';
      }
    });
  }

  private async locateCurrentPosition(): Promise<void> {
    const granted = await requestLocationPermission(this.getUIContext());
    if (!granted) {
      this.locationText = '定位权限未授予';
      return;
    }

    const location = await getCurrentLocation();
    if (!location) {
      this.locationText = '获取位置失败';
      return;
    }

    this.locationText =
      `纬度: ${location.latitude.toFixed(6)}, 经度: ${location.longitude.toFixed(6)}`;

    const opened = await openBaiduMapWithLocation(
      this.getUIContext(),
      location.latitude,
      location.longitude,
    );
    if (!opened) {
      this.locationText = '未安装百度地图或打开失败';
    }
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.home_title'))
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)

        Button($r('app.string.open_baidu'))
          .fontSize(14)
          .height(32)
          .onClick(() => {
            this.locateCurrentPosition();
          })
      }
      .width('100%')
      .padding({ left: 12, right: 12, top: 8, bottom: 8 })

      if (this.locationText.length > 0) {
        Text(this.locationText)
          .fontSize(12)
          .fontColor('#666666')
          .width('100%')
          .padding({ left: 12, right: 12, bottom: 4 })
      }

      Stack() {
        MapComponent({
          mapOptions: this.mapOptions,
          mapCallback: this.mapCallback,
        })
          .width('100%')
          .height('100%')

        if (!this.mapReady && this.mapStatusText.length > 0) {
          Column() {
            Text(this.mapStatusText)
              .fontSize(14)
              .fontColor('#666666')
              .textAlign(TextAlign.Center)
              .margin({ bottom: 8 })

            Text($r('app.string.map_setup_hint'))
              .fontSize(12)
              .fontColor('#999999')
              .textAlign(TextAlign.Center)
              .padding({ left: 24, right: 24 })
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#F5F5F5')
        }
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
