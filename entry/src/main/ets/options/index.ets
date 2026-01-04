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
      value: $r("app.string.web_options_dark_mode_auto")
    }
  }, {
  rawValue: WebDarkMode.On,
  show: {
    value: $r("app.string.web_options_dark_mode_on")
  }
}, {
  rawValue: WebDarkMode.Off,
  show: {
    value: $r("app.string.web_options_dark_mode_off")
  }
}
]

export interface KWebValue {
  javaScriptAccess: boolean,
  domStorageAccess: boolean,
  darkMode: WebDarkMode,
  forceDarkAccess: boolean
}

export const defaultInitValue: KWebValue = {
  javaScriptAccess: true,
  domStorageAccess: true,
  darkMode: WebDarkMode.Auto,
  forceDarkAccess: false
}

@ObservedV2
export class KWebOptions {
  @Trace javaScriptAccess: boolean;
  @Trace domStorageAccess: boolean;
  @Trace darkMode: WebDarkMode;
  @Trace forceDarkAccess: boolean;

  constructor(options: Optional<KWebValue> = defaultInitValue) {
    this.javaScriptAccess = options.javaScriptAccess ?? defaultInitValue.javaScriptAccess
    this.domStorageAccess = options.domStorageAccess ?? defaultInitValue.domStorageAccess
    this.darkMode = options.darkMode ?? defaultInitValue.darkMode
    this.forceDarkAccess = options.forceDarkAccess ?? defaultInitValue.forceDarkAccess
  }

  toRaw(): KWebValue {
    return {
      javaScriptAccess: this.javaScriptAccess,
      domStorageAccess: this.domStorageAccess,
      darkMode: this.darkMode,
      forceDarkAccess: this.forceDarkAccess
    }
  }
}
