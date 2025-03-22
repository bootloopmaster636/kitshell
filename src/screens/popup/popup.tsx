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

import { invoke } from "@tauri-apps/api/core";

export enum PopupPosition {
  Left = "left",
  Center = "center",
  Right = "right",
}

export interface PopupInitArgs {
  position: PopupPosition;
  width: number;
  height: number;
  path: string;
}

export function showPopup(args: PopupInitArgs) {
  invoke("show_popup", {
    popupWidth: args.width,
    popupHeight: args.height,
    popupPosition: args.position,
    path: args.path,
  });
}

export function hidePopup() {
  invoke("hide_popup");
}

export default function PopUp() {
  return (
    <div className="h-screen w-screen rounded-xl bg-red-400 p-2">
      <p>Please implement the popup function!</p>
    </div>
  );
}
