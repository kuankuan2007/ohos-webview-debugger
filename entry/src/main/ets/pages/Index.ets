import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { LengthMetrics } from '@kit.ArkUI';
import { KWebOptions, defaultInitValue, KWebValue } from '../options';
import { ConfigList } from '../options/main';
import { deviceInfo } from '@kit.BasicServicesKit';
import { addSaveCallback, getPreferences } from '../data'
import { preferences } from "@kit.ArkData"

@Entry
@ComponentV2
struct Main {
  private controller: webview.WebviewController = new webview.WebviewController();
  private preference?: preferences.Preferences;
  @Local url: string = 'www.example.com';
  @Local options: KWebOptions = new KWebOptions()
  private settingCustomDialogController = new CustomDialogController({
    builder: this.settingDialog,
    backgroundColor: $r("sys.color.background_secondary"),
    alignment: deviceInfo.deviceType === deviceInfo.DeviceTypes.TYPE_PHONE ? DialogAlignment.Bottom :
      DialogAlignment.Default
  })

  aboutToAppear(): void {
    getPreferences((val) => {
      this.preference = val
      this.initFromPreferences()
    })
  }

  private initFromPreferences() {
    if (!this.preference) {
      throw new Error("Preferences not found")
    }
    addSaveCallback(() => {
      this.saveData();
    })
    this.preference.get("url", "www.example.com", (err, data) => {
      if (err) {
        throw err as Error;
      }
      this.url = data as string;
      this.refresh()
    })
    this.preference.get("options", defaultInitValue, (err, data) => {
      if (err) {
        throw err as Error;
      }
      this.options = new KWebOptions(data as KWebValue);
    })
  }

  private async saveData() {
    console.info("Saving data")
    if (!this.preference) {
      return;
    }
    try {
      await this.preference.put("url", this.url)
      await this.preference.put("options", this.options.toRaw())
      await this.preference.flush()
    } catch (err) {
      console.error("Fail to save options", err)
    }
    console.info("Data Saved")
  }

  refresh() {
    try {
      if (this.url) {
        this.controller.loadUrl(this.url);
      }
    } catch (error) {
      console.error(`ErrorCode: ${(error as BusinessError).code}, Message: ${(error as BusinessError).message}`);
    }
  }

  @Builder
  settingDialog() {
    Column(){

      ConfigList({
        options: this.options
      })
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Flex({
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.SpaceBetween,
        space: { main: LengthMetrics.vp(5) }
      }) {
        TextInput({ placeholder: '请输入URL', text: this.url })
          .height(40)
          .type(InputType.URL)
          .enterKeyType(EnterKeyType.Go)
          .onChange((value: string) => {
            this.url = value;
          })
          .onSubmit(() => this.refresh())

        Button() {
          SymbolGlyph($r("sys.symbol.arrow_clockwise"))
            .fontColor([$r("sys.color.icon_primary")])
            .fontSize(25)
        }
        .onClick(() => this.refresh())
        .height(50)
        .width(50)
        .buttonStyle(ButtonStyleMode.NORMAL)
        .type(ButtonType.Circle)

        Button() {
          SymbolGlyph($r("sys.symbol.gearshape"))
            .fontColor([$r("sys.color.icon_primary")])
            .fontSize(25)
        }
        .onClick(() => this.settingCustomDialogController.open())
        .height(50)
        .width(50)
        .buttonStyle(ButtonStyleMode.NORMAL)
        .type(ButtonType.Circle)
      }
      .width("100%")
      .padding(10)
      .backgroundColor($r("sys.color.background_primary"))

      Web({ src: this.url, controller: this.controller })
        .width('100%')
        .height('100%')
        .onLoadIntercept((event) => {
          const url = event.data.getRequestUrl();
          this.url = url;
          return false;
        })
        .javaScriptAccess(this.options.javaScriptAccess)
        .domStorageAccess(this.options.domStorageAccess)
        .darkMode(this.options.darkMode)
        .forceDarkAccess(this.options.forceDarkAccess)
        .fileAccess(this.options.fileAccess)
        .imageAccess(this.options.imageAccess)
        .onlineImageAccess(this.options.onlineImageAccess)
        .overScrollMode(this.options.overScrollMode)
        .mixedMode(this.options.mixedMode)
        .zoomAccess(this.options.zoomAccess)
        .overviewModeAccess(this.options.overviewModeAccess)
        .geolocationAccess(this.options.geolocationAccess)
        .mediaPlayGestureAccess(this.options.mediaPlayGestureAccess)
        .horizontalScrollBarAccess(this.options.horizontalScrollBarAccess)
        .verticalScrollBarAccess(this.options.verticalScrollBarAccess)
        .cacheMode(this.options.cacheMode)
        .copyOptions(this.options.copyOptions)
        .textZoomRatio(this.options.textZoomRatio)
        .initialScale(this.options.initialScale)
        .blockNetwork(this.options.blockNetwork)
        .defaultFontSize(this.options.defaultFontSize)
        .defaultFixedFontSize(this.options.defaultFixedFontSize)
        .minFontSize(this.options.minFontSize)
        .minLogicalFontSize(this.options.minLogicalFontSize)
        .webFixedFont(this.options.webFixedFont)
        .webSansSerifFont(this.options.webSansSerifFont)
        .webSerifFont(this.options.webSerifFont)
        .webStandardFont(this.options.webStandardFont)
        .webFantasyFont(this.options.webFantasyFont)
        .webCursiveFont(this.options.webCursiveFont)
        .pinchSmooth(this.options.pinchSmooth)
        .layoutMode(this.options.layoutMode)
        .bypassVsyncCondition(this.options.bypassVsyncCondition)
        .enableNativeEmbedMode(this.options.enableNativeEmbedMode)
        .forceDisplayScrollBar(this.options.forceDisplayScrollBar)
        .defaultTextEncodingFormat(this.options.defaultTextEncodingFormat)
        .metaViewport(this.options.metaViewport)
        .textAutosizing(this.options.textAutosizing)
        .keyboardAvoidMode(this.options.keyboardAvoidMode)
        .blurOnKeyboardHideMode(this.options.blurOnKeyboardHideMode)
        .enableFollowSystemFontWeight(this.options.enableFollowSystemFontWeight)
        .enableWebAVSession(this.options.enableWebAVSession)
        .enableDataDetector(this.options.enableDataDetector)
        .gestureFocusMode(this.options.gestureFocusMode)
    }
    .width('100%')
    .height('100%')
  }
}