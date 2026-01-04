import { preferences } from "@kit.ArkData"
import { common } from '@kit.AbilityKit';
let dataPreferences: preferences.Preferences | null = null;
type PreferencesGetter = (val: preferences.Preferences) => void;
const onPreferencesLoadedFunctions: PreferencesGetter[] = [];

export function getPreferences(getter: PreferencesGetter) {
  if (dataPreferences !== null) {
    getter(dataPreferences)
  } else {
    onPreferencesLoadedFunctions.push(getter)
  }
}
export function init(context:common.Context){
  preferences.getPreferences(context, 'main', (err, val) => {
    if (err) {
      console.error("Failed to get preferences. code =" + err.code + ", message =" + err.message);
      return;
    }
    dataPreferences = val;
    console.info("Succeeded in getting preferences.");
    onPreferencesLoadedFunctions.forEach(i => {
      try {
        i(val)
      } catch (err) {
        console.error("Error on preferences callback", err)
      }
    })
  })
}
const saveCallbacks:(()=>void)[]=[]
export function addSaveCallback(callback:()=>void){
  saveCallbacks.push(callback)
}
export function save(){
  saveCallbacks.forEach(i => {
    try {
      i()
    } catch (err) {
      console.error("Error on save callback", err)
    }
  })
}