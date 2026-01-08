export class ConfigItemToggle {
  readonly type = "Toggle"
  readonly title: ResourceStr
  readonly toggleType: ToggleType

  constructor(title: ResourceStr, toggleType: ToggleType) {
    this.title = title
    this.toggleType = toggleType
  }
}

export interface SelectValueMap<T> {
  rawValue: T,
  show: SelectOption
}

export const DarkModeValues: readonly SelectValueMap<WebDarkMode>[] = [
  {
    rawValue: WebDarkMode.Auto,
    show: {
      value: $r("app.string.web_options_dark_mode_value_auto")
    }
  }, {
  rawValue: WebDarkMode.On,
  show: {
    value: $r("app.string.web_options_dark_mode_value_on")
  }
}, {
  rawValue: WebDarkMode.Off,
  show: {
    value: $r("app.string.web_options_dark_mode_value_off")
  }
}
]

export const OverScrollValues: readonly SelectValueMap<OverScrollMode>[] = [
  {
    rawValue: OverScrollMode.NEVER,
    show: {
      value: $r("app.string.web_options_over_scroll_mode_value_never")
    }
  },
  {
    rawValue: OverScrollMode.ALWAYS,
    show: {
      value: $r("app.string.web_options_over_scroll_mode_value_always")
    }
  }
]

export const MixedModeValues: readonly SelectValueMap<MixedMode>[] = [
  {
    rawValue: MixedMode.None,
    show: {
      value: $r("app.string.web_options_mixed_mode_value_none")
    }
  },
  {
    rawValue: MixedMode.Compatible,
    show: {
      value: $r("app.string.web_options_mixed_mode_value_compatible")
    }
  },
  {
    rawValue: MixedMode.All,
    show:
    {
      value: $r("app.string.web_options_mixed_mode_value_all")
    }
  }
]

export const CacheModeValues: readonly SelectValueMap<CacheMode>[] = [
  {
    rawValue: CacheMode.Default,
    show: {
      value: $r("app.string.web_options_cache_mode_value_default")
    }
  },
  {
    rawValue: CacheMode.None,
    show: {
      value: $r("app.string.web_options_cache_mode_value_none")
    }
  },
  {
    rawValue: CacheMode.Online,
    show: {
      value: $r("app.string.web_options_cache_mode_value_online")
    }
  },
  {
    rawValue: CacheMode.Only,
    show: {
      value: $r("app.string.web_options_cache_mode_value_only")
    }
  }
]

export const CopyOptionsValues: readonly SelectValueMap<CopyOptions>[]= [
  {
    rawValue: CopyOptions.LocalDevice,
    show: {
      value: $r("app.string.web_options_copy_options_value_local_device")
    }
  },
  {
    rawValue: CopyOptions.InApp,
    show: {
      value: $r("app.string.web_options_copy_options_value_in_app")
    }
  },
  {
    rawValue: CopyOptions.None,
    show: {
      value: $r("app.string.web_options_copy_options_value_none")
    }
  }
]

// TODO: mediaOptions
// TODO: multiWindowAccess
// TODO: javaScriptOnDocument
// TODO: nestedScroll
// TODO: registerNativeEmbedRule
// TODO: enableNativeMediaPlayer
// TODO: onAdsBlocked
// TODO: editMenuOptions
// TODO: bindSelectionMenu
// TODO: optimizeParserBudget
export interface KWebValue {
  javaScriptAccess: boolean,
  domStorageAccess: boolean,
  darkMode: WebDarkMode,
  forceDarkAccess: boolean,
  fileAccess: boolean,
  imageAccess: boolean,
  onlineImageAccess: boolean,
  overScrollMode: OverScrollMode,
  mixedMode: MixedMode,
  zoomAccess: boolean,
  overviewModeAccess: boolean,
  geolocationAccess: boolean,
  mediaPlayGestureAccess: boolean,
  horizontalScrollBarAccess: boolean,
  verticalScrollBarAccess: boolean,
  cacheMode: CacheMode,
  copyOptions: CopyOptions,
  textZoomRatio: number,
  initialScale: number,
  blockNetwork: boolean,
  defaultFontSize: number,
  defaultFixedFontSize: number,
  minFontSize: number,
  minLogicalFontSize: number,
  webFixedFont: string,
  webSansSerifFont: string,
  webSerifFont: string,
  webStandardFont: string,
  webFantasyFont: string,
  webCursiveFont: string,
  pinchSmooth: boolean,
  layoutMode: WebLayoutMode,
  bypassVsyncCondition: WebBypassVsyncCondition,
  enableNativeEmbedMode: boolean,
  forceDisplayScrollBar: boolean, // TODO: 即layoutMode为WebLayoutMode.FIT_CONTENT模式时，参数enabled为false
  defaultTextEncodingFormat: string,
  metaViewport: boolean,
  textAutosizing: boolean,
  keyboardAvoidMode: WebKeyboardAvoidMode,
  blurOnKeyboardHideMode: BlurOnKeyboardHideMode,
  enableFollowSystemFontWeight: boolean,
  enableWebAVSession: boolean,
  enableDataDetector: boolean, // TODO: dataDetectorConfig
  gestureFocusMode: GestureFocusMode
}

export const defaultInitValue: KWebValue = {
  javaScriptAccess: true,
  domStorageAccess: true,
  darkMode: WebDarkMode.Auto,
  forceDarkAccess: false,
  fileAccess: false,
  imageAccess: true,
  onlineImageAccess: true,
  overScrollMode: OverScrollMode.NEVER,
  mixedMode: MixedMode.None,
  zoomAccess: true,
  overviewModeAccess: true,
  geolocationAccess: true,
  mediaPlayGestureAccess: true,
  horizontalScrollBarAccess: true,
  verticalScrollBarAccess: true,
  cacheMode: CacheMode.Default,
  copyOptions: CopyOptions.LocalDevice,
  textZoomRatio: 100,
  initialScale: 100,
  blockNetwork: false,
  defaultFontSize: 16,
  defaultFixedFontSize: 13,
  minFontSize: 8,
  minLogicalFontSize: 8,
  webFixedFont: "monospace",
  webSansSerifFont: "sans-serif",
  webSerifFont: "serif",
  webStandardFont: "sans-serif",
  webFantasyFont: "fantasy",
  webCursiveFont: "cursive",
  pinchSmooth: false,
  layoutMode: WebLayoutMode.NONE,
  bypassVsyncCondition: WebBypassVsyncCondition.NONE,
  enableNativeEmbedMode: false,
  forceDisplayScrollBar: false,
  defaultTextEncodingFormat: "UTF-8",
  metaViewport: true,
  textAutosizing: true,
  keyboardAvoidMode: WebKeyboardAvoidMode.RESIZE_CONTENT,
  blurOnKeyboardHideMode: BlurOnKeyboardHideMode.SILENT,
  enableFollowSystemFontWeight: true,
  enableWebAVSession: true,
  enableDataDetector: false,
  gestureFocusMode: GestureFocusMode.DEFAULT,
}

@ObservedV2
export class KWebOptions {
  @Trace javaScriptAccess: boolean;
  @Trace domStorageAccess: boolean;
  @Trace darkMode: WebDarkMode;
  @Trace forceDarkAccess: boolean;
  @Trace fileAccess: boolean;
  @Trace imageAccess: boolean;
  @Trace onlineImageAccess: boolean;
  @Trace overScrollMode: OverScrollMode;
  @Trace mixedMode: MixedMode;
  @Trace zoomAccess: boolean;
  @Trace overviewModeAccess: boolean;
  @Trace geolocationAccess: boolean;
  @Trace mediaPlayGestureAccess: boolean;
  @Trace horizontalScrollBarAccess: boolean;
  @Trace verticalScrollBarAccess: boolean;
  @Trace cacheMode: CacheMode;
  @Trace copyOptions: CopyOptions;
  @Trace textZoomRatio: number;
  @Trace initialScale: number;
  @Trace blockNetwork: boolean;
  @Trace defaultFontSize: number;
  @Trace defaultFixedFontSize: number;
  @Trace minFontSize: number;
  @Trace minLogicalFontSize: number;
  @Trace webFixedFont: string;
  @Trace webSansSerifFont: string;
  @Trace webSerifFont: string;
  @Trace webStandardFont: string;
  @Trace webFantasyFont: string;
  @Trace webCursiveFont: string;
  @Trace pinchSmooth: boolean;
  @Trace layoutMode: WebLayoutMode;
  @Trace bypassVsyncCondition: WebBypassVsyncCondition;
  @Trace enableNativeEmbedMode: boolean;
  @Trace forceDisplayScrollBar: boolean;
  @Trace defaultTextEncodingFormat: string;
  @Trace metaViewport: boolean;
  @Trace textAutosizing: boolean;
  @Trace keyboardAvoidMode: WebKeyboardAvoidMode;
  @Trace blurOnKeyboardHideMode: BlurOnKeyboardHideMode;
  @Trace enableFollowSystemFontWeight: boolean;
  @Trace enableWebAVSession: boolean;
  @Trace enableDataDetector: boolean;
  @Trace gestureFocusMode: GestureFocusMode;

  constructor(options: Optional<KWebValue> = defaultInitValue) {
    this.javaScriptAccess = options.javaScriptAccess ?? defaultInitValue.javaScriptAccess
    this.domStorageAccess = options.domStorageAccess ?? defaultInitValue.domStorageAccess
    this.darkMode = options.darkMode ?? defaultInitValue.darkMode
    this.forceDarkAccess = options.forceDarkAccess ?? defaultInitValue.forceDarkAccess
    this.fileAccess = options.fileAccess ?? defaultInitValue.fileAccess
    this.imageAccess = options.imageAccess ?? defaultInitValue.imageAccess
    this.onlineImageAccess = options.onlineImageAccess ?? defaultInitValue.onlineImageAccess
    this.overScrollMode = options.overScrollMode ?? defaultInitValue.overScrollMode
    this.mixedMode = options.mixedMode ?? defaultInitValue.mixedMode
    this.zoomAccess = options.zoomAccess ?? defaultInitValue.zoomAccess
    this.overviewModeAccess = options.overviewModeAccess ?? defaultInitValue.overviewModeAccess
    this.geolocationAccess = options.geolocationAccess ?? defaultInitValue.geolocationAccess
    this.mediaPlayGestureAccess = options.mediaPlayGestureAccess ?? defaultInitValue.mediaPlayGestureAccess
    this.horizontalScrollBarAccess = options.horizontalScrollBarAccess ?? defaultInitValue.horizontalScrollBarAccess
    this.verticalScrollBarAccess = options.verticalScrollBarAccess ?? defaultInitValue.verticalScrollBarAccess
    this.cacheMode = options.cacheMode ?? defaultInitValue.cacheMode
    this.copyOptions = options.copyOptions ?? defaultInitValue.copyOptions
    this.textZoomRatio = options.textZoomRatio ?? defaultInitValue.textZoomRatio
    this.initialScale = options.initialScale ?? defaultInitValue.initialScale
    this.blockNetwork = options.blockNetwork ?? defaultInitValue.blockNetwork
    this.defaultFontSize = options.defaultFontSize ?? defaultInitValue.defaultFontSize
    this.defaultFixedFontSize = options.defaultFixedFontSize ?? defaultInitValue.defaultFixedFontSize
    this.minFontSize = options.minFontSize ?? defaultInitValue.minFontSize
    this.minLogicalFontSize = options.minLogicalFontSize ?? defaultInitValue.minLogicalFontSize
    this.webFixedFont = options.webFixedFont ?? defaultInitValue.webFixedFont
    this.webSansSerifFont = options.webSansSerifFont ?? defaultInitValue.webSansSerifFont
    this.webSerifFont = options.webSerifFont ?? defaultInitValue.webSerifFont
    this.webStandardFont = options.webStandardFont ?? defaultInitValue.webStandardFont
    this.webFantasyFont = options.webFantasyFont ?? defaultInitValue.webFantasyFont
    this.webCursiveFont = options.webCursiveFont ?? defaultInitValue.webCursiveFont
    this.pinchSmooth = options.pinchSmooth ?? defaultInitValue.pinchSmooth
    this.layoutMode = options.layoutMode ?? defaultInitValue.layoutMode
    this.bypassVsyncCondition = options.bypassVsyncCondition ?? defaultInitValue.bypassVsyncCondition
    this.enableNativeEmbedMode = options.enableNativeEmbedMode ?? defaultInitValue.enableNativeEmbedMode
    this.forceDisplayScrollBar = options.forceDisplayScrollBar ?? defaultInitValue.forceDisplayScrollBar
    this.defaultTextEncodingFormat = options.defaultTextEncodingFormat ?? defaultInitValue.defaultTextEncodingFormat
    this.metaViewport = options.metaViewport ?? defaultInitValue.metaViewport
    this.textAutosizing = options.textAutosizing ?? defaultInitValue.textAutosizing
    this.keyboardAvoidMode = options.keyboardAvoidMode ?? defaultInitValue.keyboardAvoidMode
    this.blurOnKeyboardHideMode = options.blurOnKeyboardHideMode ?? defaultInitValue.blurOnKeyboardHideMode
    this.enableFollowSystemFontWeight =
      options.enableFollowSystemFontWeight ?? defaultInitValue.enableFollowSystemFontWeight
    this.enableWebAVSession = options.enableWebAVSession ?? defaultInitValue.enableWebAVSession
    this.enableDataDetector = options.enableDataDetector ?? defaultInitValue.enableDataDetector
    this.gestureFocusMode = options.gestureFocusMode ?? defaultInitValue.gestureFocusMode
  }

  toRaw(): KWebValue {
    return {
      javaScriptAccess: this.javaScriptAccess,
      domStorageAccess: this.domStorageAccess,
      darkMode: this.darkMode,
      forceDarkAccess: this.forceDarkAccess,
      fileAccess: this.fileAccess,
      imageAccess: this.imageAccess,
      onlineImageAccess: this.onlineImageAccess,
      overScrollMode: this.overScrollMode,
      mixedMode: this.mixedMode,
      zoomAccess: this.zoomAccess,
      overviewModeAccess: this.overviewModeAccess,
      geolocationAccess: this.geolocationAccess,
      mediaPlayGestureAccess: this.mediaPlayGestureAccess,
      horizontalScrollBarAccess: this.horizontalScrollBarAccess,
      verticalScrollBarAccess: this.verticalScrollBarAccess,
      cacheMode: this.cacheMode,
      copyOptions: this.copyOptions,
      textZoomRatio: this.textZoomRatio,
      initialScale: this.initialScale,
      blockNetwork: this.blockNetwork,
      defaultFontSize: this.defaultFontSize,
      defaultFixedFontSize: this.defaultFixedFontSize,
      minFontSize: this.minFontSize,
      minLogicalFontSize: this.minLogicalFontSize,
      webFixedFont: this.webFixedFont,
      webSansSerifFont: this.webSansSerifFont,
      webSerifFont: this.webSerifFont,
      webStandardFont: this.webStandardFont,
      webFantasyFont: this.webFantasyFont,
      webCursiveFont: this.webCursiveFont,
      pinchSmooth: this.pinchSmooth,
      layoutMode: this.layoutMode,
      bypassVsyncCondition: this.bypassVsyncCondition,
      enableNativeEmbedMode: this.enableNativeEmbedMode,
      forceDisplayScrollBar: this.forceDisplayScrollBar,
      defaultTextEncodingFormat: this.defaultTextEncodingFormat,
      metaViewport: this.metaViewport,
      textAutosizing: this.textAutosizing,
      keyboardAvoidMode: this.keyboardAvoidMode,
      blurOnKeyboardHideMode: this.blurOnKeyboardHideMode,
      enableFollowSystemFontWeight: this.enableFollowSystemFontWeight,
      enableWebAVSession: this.enableWebAVSession,
      enableDataDetector: this.enableDataDetector,
      gestureFocusMode: this.gestureFocusMode
    }
  }
}
