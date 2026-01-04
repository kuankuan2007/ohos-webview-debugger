import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { LengthMetrics } from '@kit.ArkUI';
import {  KWebOptions } from '../options';
import { ConfigList } from '../options/main';




@Entry
@ComponentV2
struct Main {
  private controller: webview.WebviewController = new webview.WebviewController();
  @Local private url: string = 'www.example.com';
  @Local private options:KWebOptions=new KWebOptions({
    javaScriptAccess:true,
    domStorageAccess:true,
    darkMode:WebDarkMode.Auto,
    forceDarkAccess:false
  })
  private settingCustomDialogController=new CustomDialogController({
    builder:this.settingDialog,
    backgroundColor:$r("app.color.first_background"),
  })
  refresh(){
    try {
      if (this.url) {
        this.controller.loadUrl(this.url);
      }
    } catch (error) {
      console.error(`ErrorCode: ${(error as BusinessError).code}, Message: ${(error as BusinessError).message}`);
    }
  }
  @Builder
  settingDialog(){
    ConfigList({
      options:this.options
    }).background($r("app.color.first_background"))
  }
  build() {
    Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.SpaceBetween,alignItems:ItemAlign.Center}) {
      Flex({alignItems:ItemAlign.Center,justifyContent:FlexAlign.SpaceBetween,space:{main:LengthMetrics.vp(5)}}){
        TextInput({ placeholder: '请输入URL',text:this.url })
          .height(40)
          .type(InputType.URL)
          .enterKeyType(EnterKeyType.Go)
          .onChange((value: string) => {
            this.url = value;
          }).onSubmit(()=>this.refresh())

        Button(){
          Image($r("app.media.arrow_clockwise"))
            .width(25)
            .height(25)
            .fillColor($r("app.color.text_color"))
        }
        .onClick(()=>this.refresh())
        .height(50)
        .width(50)
        .buttonStyle(ButtonStyleMode.NORMAL)
        .type(ButtonType.Circle)

        Button(){
          Image($r("app.media.gearshape"))
            .width(25)
            .height(25)
            .fillColor($r("app.color.text_color"))
        }
        .onClick(()=>this.settingCustomDialogController.open())
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
        .onLoadIntercept((event)=>{
          const url=event.data.getRequestUrl();
          this.url=url;
          return false;
        })
        .darkMode(this.options.darkMode)
        .forceDarkAccess(this.options.forceDarkAccess)
    }
    .width('100%')
    .height('100%')
  }
}