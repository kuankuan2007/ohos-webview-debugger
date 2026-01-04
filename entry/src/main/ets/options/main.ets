import { DarkModeValues, KWebOptions } from '.'

@ComponentV2
struct ItemBase{
  @Param hide:boolean=false
  @BuilderParam inner:()=>void
  build() {
    Row(){
      this.inner()
    }.width("100%")
    .height(this.hide?0:42)
    .opacity(this.hide?0:1)
    .animation({duration:300,curve:Curve.EaseInOut})
    .clip(true)
  }
}

@ComponentV2
struct ItemToggle{
  @Param @Require title:ResourceStr;
  @Param @Require value:boolean;
  @Param @Require type:ToggleType
  @Event onChange:(value:boolean)=>void;
  @Param hide:boolean=false

  build() {
    ItemBase({hide:this.hide}){
      Text(this.title)
        .fontSize($r("app.float.item_fontsize"))
      Blank()
      Toggle({
          type:this.type,
          isOn:this.value
        }).onChange((v)=>{
          if (this.value!==v){
            this.onChange(v)
          }
      })
    }
  }
}

@ComponentV2
struct ItemSwitch{
  @Param @Require title:ResourceStr;
  @Param @Require selections:SelectOption[]
  @Param @Require value:number
  @Event onChange:(value:number)=>void
  @Param hide:boolean=false

  build() {
    ItemBase({hide:this.hide}){
      Text(this.title)
        .fontSize($r("app.float.item_fontsize"))
      Blank()
      Select(this.selections)
        .onSelect((v)=>{

          if (this.value!==v){
            this.onChange(v)
          }
        })
        .selected(this.value)
        .value(this.selections[this.value].value)
    }
  }
}

class MyListItemGroupStyle implements  AttributeModifier<ListItemGroupAttribute>{
  applyNormalAttribute(instance:ListItemGroupAttribute): void {
    instance
      .padding({
        top: 5,
        left: 10,
        right: 10,
        bottom: 5
      })
      .backgroundColor($r("app.color.second_background"))
  }

}
class MyListItemStyle implements AttributeModifier<ListItemAttribute>{
  applyNormalAttribute(instance: ListItemAttribute): void {
    instance
      .padding({
        left:5,
      })
  }
  applyDisabledAttribute(instance: ListItemAttribute): void {
    instance.background(Color.Red)
  }
}

@ComponentV2
export struct ConfigList{
  @Param @Require  options: KWebOptions
  @Local itemGroupStyle:MyListItemGroupStyle =new MyListItemGroupStyle()
  @Local itemStyle:MyListItemStyle =new MyListItemStyle()
  @Builder
  itemHeader(text:string|Resource){
    Text(text)
      .textAlign(TextAlign.Start)
      .fontSize($r("app.float.item_title_fontsize"))
      .width("100%")
      .fontWeight(FontWeight.Bold)
      .margin({
        left:0,
        top:10,
        bottom:10,
        right:0
      })
  }
  build() {
    // Text("Hello")
    List({
      space:15
    }){
      ListItemGroup({
        header: this.itemHeader($r("app.string.web_options_basic_ability")),
        style:ListItemGroupStyle.CARD,
        space:5
      }){
        ListItem(){
          ItemToggle({
              title:$r("app.string.java_script_access"),
              type:ToggleType.Switch,
              value:this.options.javaScriptAccess,
              onChange:(value:boolean)=>this.options.javaScriptAccess=value
            })
        }.attributeModifier(this.itemStyle)
        ListItem(){
          ItemToggle({
            title:$r("app.string.dom_storage_access"),
            type:ToggleType.Switch,
            value:this.options.domStorageAccess,
            onChange:(value:boolean)=>this.options.domStorageAccess=value
          })
        }.attributeModifier(this.itemStyle)
      }.attributeModifier(this.itemGroupStyle)

      ListItemGroup({
        header: this.itemHeader($r("app.string.web_options_dark_mode")),
        style:ListItemGroupStyle.CARD,
        space:5
      }){
        ListItem(){
          ItemSwitch({
            title:$r("app.string.web_options_dark_mode"),
            selections:DarkModeValues.map(i=>i.show),
            value:DarkModeValues.findIndex(i=>i.rawValue===this.options.darkMode),
            onChange:(value)=>{
              this.options.darkMode=DarkModeValues[value].rawValue
            }
          })
        }.attributeModifier(this.itemStyle)
        ListItem(){
          ItemToggle({
            title:$r("app.string.web_options_force_dark_access"),
            type:ToggleType.Switch,
            value:this.options.forceDarkAccess,
            onChange:(value:boolean)=>this.options.forceDarkAccess=value,
            hide:this.options.darkMode===WebDarkMode.Off
          })
        }.attributeModifier(this.itemStyle)
      }.attributeModifier(this.itemGroupStyle)
    }
    .width("100%")
    .height("100%")
    .padding({
      left:10,
      right:10,
      top:15,
      bottom:15
    })
  }
}