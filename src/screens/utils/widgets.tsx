import { ReactNode } from "react";

export enum Alignment {
  start,
  center,
  end,
}

export class Widget {
  build({ alignment, key }: { alignment: Alignment; key: string }): ReactNode {
    return (
      <div
        key={key}
        className="flex items-center bg-red-600 px-4 text-yellow-300"
        style={{
          alignItems: GetAlignment(alignment),
        }}
      >
        Please implement build method!
      </div>
    );
  }
}

export function GetAlignment(align: Alignment) {
  switch (align) {
    case Alignment.start:
      return "flex-start";
    case Alignment.center:
      return "center";
    case Alignment.end:
      return "flex-end";
  }
}
