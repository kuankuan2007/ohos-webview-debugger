import {
  BlurOnKeyboardHideModeValues,
  CacheModeValues,
  CopyOptionsValues,
  DarkModeValues,
  GestureFocusModeValues,
  KeyboardAvoidModeValues,
  KWebOptions,
  LayoutModeValues,
  MixedModeValues,
  OverScrollValues
} from '.'


interface Help {
  title: ResourceStr,
  content: ResourceStr
}

@ComponentV2
struct ItemBase {
  @Param hide: boolean = false
  @Param @Require title: ResourceStr;
  @Param resetButton: boolean = false;
  @BuilderParam inner: () => void
  @Param help?: Help = void 0;
  @Event onReset: () => void

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
      if (this.resetButton) {
        Button() {
          SymbolGlyph($r("sys.symbol.undo"))
            .fontColor([$r("sys.color.icon_tertiary")])
        }
        .type(ButtonType.Circle)
        .buttonStyle(ButtonStyleMode.TEXTUAL)
        .width(35)
        .margin({ left: 3 })
        .onClick(() => this.onReset())
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

@ComponentV2
struct ItemNumber {
  @Param @Require title: ResourceStr;
  @Param @Require value: number
  @Param min: number = 0;
  @Param max: number = 1000;
  @Param default: number = 100;
  @Event onChange: (value: number) => void
  @Param hide: boolean = false
  @Param help?: Help = void 0;

  build() {
    ItemBase({
      hide: this.hide,
      title: this.title,
      help: this.help,
      resetButton: true,
      onReset: () => this.onChange(this.default)
    }) {
      TextInput({
        text: this.value.toString()
      })
        .type(InputType.Number)
        .onChange((value) => {
          const numValue = Number(value)
          let res: number = numValue;
          if (Number.isNaN(numValue)) {
            res = this.default
          } else if (numValue > this.max) {
            res = this.max
          } else if (numValue < this.min) {
            res = this.min
          }
          this.onChange(res);
        })
        .width(80)
        .textAlign(TextAlign.Center)
    }
  }
}

@ComponentV2
struct ItemString {
  @Param @Require title: ResourceStr;
  @Param @Require value: string
  @Event onChange: (value: string) => void
  @Param hide: boolean = false
  @Param help?: Help = void 0;
  @Param default: string = '';

  build() {
    ItemBase({
      hide: this.hide,
      title: this.title,
      help: this.help,
      resetButton: Boolean(this.default),
      onReset: () => this.onChange(this.default)
    }) {
      TextInput({
        text: this.value
      })
        .type(InputType.Normal)
        .onChange((value) => {
          this.onChange(value);
        })
        .width(120)
        .textAlign(TextAlign.Start)
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
        left: 15,
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
          header: this.itemHeader($r("app.string.web_options_group_basic_ability")),
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
              onChange: (value: boolean) => this.options.fileAccess = value,
              help: {
                title: "File Access",
                content: $r("app.string.web_options_file_access_help")
              }
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
            ItemToggle({
              title: $r("app.string.web_options_block_network"),
              value: this.options.blockNetwork,
              onChange: (value: boolean) => this.options.blockNetwork = value
            })
          }.attributeModifier(this.itemStyle)
        }.attributeModifier(this.itemGroupStyle)

        ListItemGroup({
          header: this.itemHeader($r("app.string.web_options_group_color_mode")),
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

        ListItemGroup({
          header: this.itemHeader($r("app.string.web_options_group_zoom")),
          style: ListItemGroupStyle.CARD,
          space: 5
        }) {
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
            ItemNumber({
              title: $r("app.string.web_options_initial_scale"),
              value: this.options.initialScale,
              onChange: (value: number) => this.options.initialScale = value,
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemNumber({
              title: $r("app.string.web_options_text_zoom_ratio"),
              value: this.options.textZoomRatio,
              onChange: (value: number) => this.options.textZoomRatio = value,
            })
          }.attributeModifier(this.itemStyle)

        }.attributeModifier(this.itemGroupStyle)

        ListItemGroup({
          header: this.itemHeader($r("app.string.web_options_group_font")),
          style: ListItemGroupStyle.CARD,
          space: 5
        }) {
          ListItem() {
            ItemNumber({
              title: $r("app.string.web_options_default_font_size"),
              value: this.options.defaultFontSize,
              onChange: (value: number) => this.options.defaultFontSize = value,
              default: 16,
              min: 1,
              max: 72
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemNumber({
              title: $r("app.string.web_options_default_font_size"),
              value: this.options.defaultFontSize,
              onChange: (value: number) => this.options.defaultFontSize = value,
              default: 16,
              min: 1,
              max: 72
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemNumber({
              title: $r("app.string.web_options_default_fixed_font_size"),
              value: this.options.defaultFixedFontSize,
              onChange: (value: number) => this.options.defaultFixedFontSize = value,
              default: 13,
              min: 1,
              max: 72
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemNumber({
              title: $r("app.string.web_options_min_font_size"),
              value: this.options.minFontSize,
              onChange: (value: number) => this.options.minFontSize = value,
              default: 8,
              min: 1,
              max: 72
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemNumber({
              title: $r("app.string.web_options_min_logical_font_size"),
              value: this.options.minLogicalFontSize,
              onChange: (value: number) => this.options.minLogicalFontSize = value,
              default: 8,
              min: 1,
              max: 72
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemString({
              title: $r("app.string.web_options_web_standard_font"),
              value: this.options.webStandardFont,
              onChange: (value: string) => this.options.webStandardFont = value,
              default: 'sans-serif',
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemString({
              title: $r("app.string.web_options_web_fixed_font"),
              value: this.options.webFixedFont,
              onChange: (value: string) => this.options.webFixedFont = value,
              default: 'monospace',
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemString({
              title: $r("app.string.web_options_web_sans_serif_font"),
              value: this.options.webSansSerifFont,
              onChange: (value: string) => this.options.webSansSerifFont = value,
              default: 'sans-serif',
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemString({
              title: $r("app.string.web_options_web_serif_font"),
              value: this.options.webSerifFont,
              onChange: (value: string) => this.options.webSerifFont = value,
              default: 'serif',
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemString({
              title: $r("app.string.web_options_web_fantasy_font"),
              value: this.options.webFantasyFont,
              onChange: (value: string) => this.options.webFantasyFont = value,
              default: 'fantasy',
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemString({
              title: $r("app.string.web_options_web_cursive_font"),
              value: this.options.webCursiveFont,
              onChange: (value: string) => this.options.webCursiveFont = value,
              default: 'cursive',
            })
          }.attributeModifier(this.itemStyle)

        }.attributeModifier(this.itemGroupStyle)

        ListItemGroup({
          header: this.itemHeader($r("app.string.web_options_group_advanced_options")),
          style: ListItemGroupStyle.CARD,
          space: 5
        }) {

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
              },
              help: {
                title: "Media Play Gesture Access",
                content: $r("app.string.web_options_media_play_gesture_access_help")
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

          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_vertical_scroll_bar_access"),
              value: this.options.verticalScrollBarAccess,
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

          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_pinch_smooth"),
              value: this.options.pinchSmooth,
              onChange: (value) => {
                this.options.pinchSmooth = value
              }
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemSwitch({
              title: $r("app.string.web_options_layout_mode"),
              selections: LayoutModeValues.map(i => i.show),
              value: LayoutModeValues.findIndex(i => i.rawValue === this.options.layoutMode),
              onChange: (value) => {
                this.options.layoutMode = LayoutModeValues[value].rawValue
              },
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_enable_native_embed_mode"),
              value: this.options.enableNativeEmbedMode,
              onChange: (value) => {
                this.options.enableNativeEmbedMode = value
              }
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_force_display_scroll_bar"),
              value: this.options.forceDisplayScrollBar,
              onChange: (value) => {
                this.options.forceDisplayScrollBar = value
              }
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemString({
              title: $r("app.string.web_options_default_text_encoding_format"),
              value: this.options.defaultTextEncodingFormat,
              onChange: (value: string) => this.options.defaultTextEncodingFormat = value,
              default: 'UTF-8',
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_meta_viewport"),
              value: this.options.metaViewport,
              onChange: (value) => {
                this.options.metaViewport = value
              }
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_text_autosizing"),
              value: this.options.textAutosizing,
              help: {
                title: "Text Autosizing",
                content: $r("app.string.web_options_text_autosizing_help")
              },
              onChange: (value) => {
                this.options.textAutosizing = value
              }
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemSwitch({
              title: $r("app.string.web_options_keyboard_avoid_mode"),
              selections: KeyboardAvoidModeValues.map(i => i.show),
              value: KeyboardAvoidModeValues.findIndex(i => i.rawValue === this.options.keyboardAvoidMode),
              onChange: (value) => {
                this.options.keyboardAvoidMode = KeyboardAvoidModeValues[value].rawValue
              },
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemSwitch({
              title: $r("app.string.web_options_blur_on_keyboard_hide_mode"),
              selections: BlurOnKeyboardHideModeValues.map(i => i.show),
              value: BlurOnKeyboardHideModeValues.findIndex(i => i.rawValue === this.options.blurOnKeyboardHideMode),
              onChange: (value) => {
                this.options.blurOnKeyboardHideMode = BlurOnKeyboardHideModeValues[value].rawValue
              },
            })
          }.attributeModifier(this.itemStyle)


          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_enable_follow_system_font_weight"),
              value: this.options.enableFollowSystemFontWeight,
              onChange: (value) => {
                this.options.enableFollowSystemFontWeight = value
              }
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_enable_web_av_session"),
              value: this.options.enableWebAVSession,
              onChange: (value) => {
                this.options.enableWebAVSession = value
              }
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemToggle({
              title: $r("app.string.web_options_enable_data_detector"),
              value: this.options.enableDataDetector,
              onChange: (value) => {
                this.options.enableDataDetector = value
              }
            })
          }.attributeModifier(this.itemStyle)

          ListItem() {
            ItemSwitch({
              title: $r("app.string.web_options_gesture_focus_mode"),
              selections: GestureFocusModeValues.map(i => i.show),
              value: GestureFocusModeValues.findIndex(i => i.rawValue === this.options.gestureFocusMode),
              onChange: (value) => {
                this.options.gestureFocusMode = GestureFocusModeValues[value].rawValue
              },
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