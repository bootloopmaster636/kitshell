import { argbFromHex, Scheme, Theme, themeFromSourceColor } from '@material/material-color-utilities';
import {create} from 'zustand';

interface ColorThemeState {
  colorSchemeLight: Scheme;
  colorSchemeDark: Scheme;
  changeColorPalette: (newColorHex: string) => void;
}

export const useMaterialColor = create<ColorThemeState>()((set) => ({
  colorSchemeLight: themeFromSourceColor(argbFromHex('#42cef5')).schemes.light,
  colorSchemeDark: themeFromSourceColor(argbFromHex('#42cef5')).schemes.dark,
  changeColorPalette: (newColorHex: string) => set({
    colorSchemeLight: themeFromSourceColor(argbFromHex(newColorHex)).schemes.light,
    colorSchemeDark: themeFromSourceColor(argbFromHex(newColorHex)).schemes.dark
  })
}))