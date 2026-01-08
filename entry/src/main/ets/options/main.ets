import { CacheModeValues, CopyOptionsValues, DarkModeValues, KWebOptions, MixedModeValues, OverScrollValues } from '.'

interface Help {
  title: ResourceStr,
  content: ResourceStr
}

@ComponentV2
struct ItemBase {
  @Param hide: boolean = false
  @Param @Require title: ResourceStr;
  @BuilderParam inner: () => void
  @Param help?: Help = void 0;

  build() {
    Row() {
      Text(this.title)
        .fontSize($r("app.float.item_fontsize"))
      if (this.help) {
        Button() {
          SymbolGlyph($r("sys.symbol.questionmark_circle"))
            .fontColor([$r("sys.color.icon_tertiary")])
        }
        .type(ButtonType.Circle)
        .buttonStyle(ButtonStyleMode.TEXTUAL)
        .width(35)
        .margin({ left: 3 })
        .onClick(() => {
          const uiContext = this.getUIContext()
          uiContext.showAlertDialog({
            title: this.help!.title,
            subtitle: $r("app.string.help"),
            message: this.help!.content,
            autoCancel: true,
            buttonDirection: DialogButtonDirection.AUTO,
            buttons: [{
              value: $r("app.string.close"),
              action: () => {
              }
            }
            ]
          })
        })
      }
      Blank()
      this.inner()
    }
    .width("100%")
    .height(this.hide ? 0 : 42)
    .opacity(this.hide ? 0 : 1)
    .animation({ duration: 300, curve: Curve.EaseInOut })
    .clip(true)
  }
}

@ComponentV2
struct ItemToggle {
  @Param @Require title: ResourceStr;
  @Param @Require value: boolean;
  @Param type: ToggleType = ToggleType.Switch
  @Event onChange: (value: boolean) => void;
  @Param hide: boolean = false
  @Param help?: Help = void 0;

  build() {
    ItemBase({ hide: this.hide, title: this.title, help: this.help }) {

      Toggle({
        type: this.type,
        isOn: this.value
      }).onChange((v) => {
        if (this.value !== v) {
          this.onChange(v)
        }
      })
    }
  }
}

@ComponentV2
struct ItemSwitch {
  @Param @Require title: ResourceStr;
  @Param @Require selections: SelectOption[]
  @Param @Require value: number
  @Event onChange: (value: number) => void
  @Param hide: boolean = false
  @Param help?: Help = void 0;

  build() {
    ItemBase({ hide: this.hide, title: this.title, help: this.help }) {
      Select(this.selections)
        .onSelect((v) => {

          if (this.value !== v) {
            this.onChange(v)
          }
        })
        .selected(this.value)
        .value(this.selections[this.value].value)
    }
  }
}

class MyListItemGroupStyle implements AttributeModifier<ListItemGroupAttribute> {
  applyNormalAttribute(instance: ListItemGroupAttribute): void {
    instance
      .backgroundColor($r("sys.color.background_tertiary"))
      .borderRadius(16)
      .clip(true)
      .margin(0)
      .padding(0)
  }
}

class MyListItemStyle implements AttributeModifier<ListItemAttribute> {
  applyNormalAttribute(instance: ListItemAttribute): void {
    instance
      .padding({
        left: 10,
        right: 10
      })
  }
}

@ComponentV2
export struct ConfigList {
  @Param @Require options: KWebOptions
  @Local itemGroupStyle: MyListItemGroupStyle = new MyListItemGroupStyle()
  @Local itemStyle: MyListItemStyle = new MyListItemStyle()

  @Builder
  itemHeader(text: string | Resource) {
    Row() {
      Text(text)
        .textAlign(TextAlign.Start)
        .fontSize($r("app.float.item_title_fontsize"))
        .fontWeight(FontWeight.Bold)

    }
    .width("100%")
    .padding({
      left: 8,
      top: 10,
      bottom: 10,
      right: 0
    })
    .margin(0)
    .background($r("sys.color.background_tertiary"))
  }

  build() {
    // Text("Hello")
    Column() {
      List({
        space: 15
      }) {
        ListItemGroup({
          header: this.itemHeader($r("app.string.web_options_basic_ability")),
          style: ListItemGroupStyle.CARD,
          space: 5
        }) {
          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_java_script_access"),
              value: this.options.javaScriptAccess,
              onChange: (value: boolean) => this.options.javaScriptAccess = value
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_dom_storage_access"),
              value: this.options.domStorageAccess,
              onChange: (value: boolean) => this.options.domStorageAccess = value
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_file_access"),
              value: this.options.fileAccess,
              onChange: (value: boolean) => this.options.fileAccess = value
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_image_access"),
              value: this.options.imageAccess,
              onChange: (value: boolean) => this.options.imageAccess = value
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_online_image_access"),
              value: this.options.onlineImageAccess,
              onChange: (value: boolean) => this.options.onlineImageAccess = value
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemSwitch({
              title: $r("app.string.web_options_over_scroll_mode"),
              selections: OverScrollValues.map(i => i.show),
              value: OverScrollValues.findIndex(i => i.rawValue === this.options.overScrollMode),
              onChange: (value) => {
                this.options.overScrollMode = OverScrollValues[value].rawValue
              }
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemSwitch({
              title: $r("app.string.web_options_mixed_mode"),
              selections: MixedModeValues.map(i => i.show),
              value: MixedModeValues.findIndex(i => i.rawValue === this.options.mixedMode),
              onChange: (value) => {
                this.options.mixedMode = MixedModeValues[value].rawValue
              },
              help: {
                title: "Mixed Mode",
                content: $r("app.string.web_options_mixed_help")
              }
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_zoom_access"),
              value: this.options.zoomAccess,
              onChange: (value) => {
                this.options.zoomAccess = value
              }
            })
          }
          .attributeModifier(this.itemStyle)

          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_overview_mode_access"),
              value: this.options.overviewModeAccess,
              onChange: (value) => {
                this.options.overviewModeAccess = value
              }
            })
          }
          .attributeModifier(this.itemStyle)

          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_geolocation_access"),
              value: this.options.geolocationAccess,
              onChange: (value) => {
                this.options.geolocationAccess = value
              }
            })
          }
          .attributeModifier(this.itemStyle)

          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_media_play_gesture_access"),
              value: this.options.mediaPlayGestureAccess,
              onChange: (value) => {
                this.options.mediaPlayGestureAccess = value
              }
            })
          }
          .attributeModifier(this.itemStyle)

          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_horizontal_scroll_bar_access"),
              value: this.options.horizontalScrollBarAccess,
              onChange: (value) => {
                this.options.horizontalScrollBarAccess = value
              }
            })
          }
          .attributeModifier(this.itemStyle)

          ListItem(){
            ItemToggle({
              title:$r("app.string.web_options_vertical_scroll_bar_access"),
              value:this.options.verticalScrollBarAccess,
              onChange: (value) => {
                this.options.verticalScrollBarAccess = value
              }
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemSwitch({
              title: $r("app.string.web_options_cache_mode"),
              selections: CacheModeValues.map(i => i.show),
              value: CacheModeValues.findIndex(i => i.rawValue === this.options.cacheMode),
              onChange: (value) => {
                this.options.cacheMode = CacheModeValues[value].rawValue
              },
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemSwitch({
              title: $r("app.string.web_options_copy_options"),
              selections: CopyOptionsValues.map(i => i.show),
              value: CopyOptionsValues.findIndex(i => i.rawValue === this.options.copyOptions),
              onChange: (value) => {
                this.options.copyOptions = CopyOptionsValues[value].rawValue
              },
            })
          }.attributeModifier(this.itemStyle)
        }.attributeModifier(this.itemGroupStyle)

        ListItemGroup({
          header: this.itemHeader($r("app.string.web_options_dark_mode")),
          style: ListItemGroupStyle.CARD,
          space: 5
        }) {
          ListItem() {
            ItemSwitch({
              title: $r("app.string.web_options_dark_mode"),
              selections: DarkModeValues.map(i => i.show),
              value: DarkModeValues.findIndex(i => i.rawValue === this.options.darkMode),
              onChange: (value) => {
                this.options.darkMode = DarkModeValues[value].rawValue
              }
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_force_dark_access"),
              value: this.options.forceDarkAccess,
              onChange: (value: boolean) => this.options.forceDarkAccess = value,
              hide: this.options.darkMode === WebDarkMode.Off
            })
          }.attributeModifier(this.itemStyle)
        }.attributeModifier(this.itemGroupStyle)
      }
      .sticky(StickyStyle.Header)
      .borderRadius(16)
      .clip(true)
      .scrollBar(BarState.Off)
      .margin(0)
      .padding(0)
      .width("100%")
      .height("100%")
    }
    .width("100%")
    .height("100%")
    .padding(20)
  }
}