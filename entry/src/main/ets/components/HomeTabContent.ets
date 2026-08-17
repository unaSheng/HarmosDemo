import { AsyncCallback, BusinessError } from '@kit.BasicServicesKit';
import { MapComponent, map, mapCommon } from '@kit.MapKit';
import { getCurrentLocation, requestLocationPermission } from '../common/LocationHelper';

@Component
export struct HomeTabContent {
  @State locationText: string = '';
  private mapOptions?: mapCommon.MapOptions;
  private mapCallback?: AsyncCallback<map.MapComponentController>;
  private mapController?: map.MapComponentController;

  aboutToAppear(): void {
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
        return;
      }
      this.mapController = mapController;
      mapController.setMyLocationEnabled(true);
      mapController.getEventManager()?.on('mapLoad', () => {
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
    if (!this.mapController) {
      this.locationText = '地图尚未就绪';
      return;
    }

    this.locationText =
      `纬度: ${location.latitude.toFixed(6)}, 经度: ${location.longitude.toFixed(6)}`;
    this.mapController.setMyLocation(location);

    const cameraUpdate = map.newCameraPosition({
      target: {
        latitude: location.latitude,
        longitude: location.longitude,
      },
      zoom: 16,
    });
    this.mapController.animateCamera(cameraUpdate, 1000);
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.home_title'))
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)

        Button($r('app.string.locate'))
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

      MapComponent({
        mapOptions: this.mapOptions,
        mapCallback: this.mapCallback,
      })
        .width('100%')
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}
