/*
 Copyright (c) 2025 Christopher Hartono

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

import { hexFromArgb } from "@material/material-color-utilities";
import { useMaterialColor } from "../../logic/color_theme";
import Color from "color";
import { centerWidgets, leftWidgets, rightWidgets } from "./panel_contents";
import { Alignment } from "../utils/widgets";

export default function MainScreen() {
  const theme = useMaterialColor((state) => state.colorSchemeLight);
  return (
    <div
      className="flex h-screen w-screen flex-row justify-evenly overflow-clip select-none"
      style={{
        backgroundColor: Color(hexFromArgb(theme.background))
          .alpha(0.8)
          .string(),
        fontFamily: "'Inter', sans-serif",
      }}
    >
      <LeftPanel />
      <CenterPanel />
      <RightPanel />
    </div>
  );
}

function LeftPanel() {
  return (
    <div className="flex w-full flex-row justify-start">
      {leftWidgets.map((widget) =>
        widget.build({ alignment: Alignment.start }),
      )}
    </div>
  );
}

function CenterPanel() {
  return (
    <div className="flex w-full flex-row justify-center">
      {centerWidgets.map((widget) =>
        widget.build({ alignment: Alignment.center }),
      )}
    </div>
  );
}

function RightPanel() {
  return (
    <div className="flex w-full flex-row justify-end">
      {rightWidgets.map((widget) => widget.build({ alignment: Alignment.end }))}
    </div>
  );
}
