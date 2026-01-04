import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { LengthMetrics } from '@kit.ArkUI';
import { KWebOptions, defaultInitValue, KWebValue } from '../options';
import { ConfigList } from '../options/main';

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
    backgroundColor: $r("app.color.first_background"),
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
    addSaveCallback(()=>{
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
    console.info("Saving datas")
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
    ConfigList({
      options: this.options
    }).background($r("app.color.first_background"))
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
          Image($r("app.media.arrow_clockwise"))
            .width(25)
            .height(25)
            .fillColor($r("app.color.text_color"))
        }
        .onClick(() => this.refresh())
        .height(50)
        .width(50)
        .buttonStyle(ButtonStyleMode.NORMAL)
        .type(ButtonType.Circle)

        Button() {
          Image($r("app.media.gearshape"))
            .width(25)
            .height(25)
            .fillColor($r("app.color.text_color"))
        }
        .onClick(() => this.settingCustomDialogController.open())
        .height(50)
        .width(50)
        .buttonStyle(ButtonStyleMode.NORMAL)
        .type(ButtonType.Circle)
      }
      .width("100%")
      .padding(10)

      Web({ src: this.url, controller: this.controller })
        .javaScriptAccess(this.options.javaScriptAccess)
        .domStorageAccess(this.options.domStorageAccess)
        .width('100%')
        .height('100%')
        .onLoadIntercept((event) => {
          const url = event.data.getRequestUrl();
          this.url = url;
          return false;
        })
        .darkMode(this.options.darkMode)
        .forceDarkAccess(this.options.forceDarkAccess)
    }
    .width('100%')
    .height('100%')
  }
}