import { ReactNode, useEffect, useState } from "react";
import { Alignment, GetAlignment, Widget } from "../../../utils/widgets";
import { useMaterialColor } from "../../../../logic/color_theme";
import { hexFromArgb } from "@material/material-color-utilities";
import NumberFlow, { NumberFlowGroup } from "@number-flow/react";
import {
  TransitionCurve,
  TransitionDuration,
} from "../../../utils/transitions";
import { hidePopup, PopupPosition, showPopup } from "../../../popup/popup";

interface DateComponent {
  year: number;
  month: number;
  day: number;
  hour: number;
  minute: number;
  second: number;
}

export class Clock extends Widget {
  build({ alignment, key }: { alignment: Alignment; key: string }): ReactNode {
    const [time, setTime] = useState<DateComponent>();
    const theme = useMaterialColor((state) => state.colorSchemeLight);

    useEffect(() => {
      const id = setInterval(() => {
        const date = new Date();
        setTime({
          year: date.getFullYear(),
          month: date.getMonth() + 1,
          day: date.getDate(),
          hour: date.getHours(),
          minute: date.getMinutes(),
          second: date.getSeconds(),
        });
      }, 1000);
      return () => clearInterval(id);
    }, []);

    return (
      <div
        key={key}
        className="flex cursor-default flex-col justify-center px-3"
        style={{
          alignItems: GetAlignment(alignment),
        }}
        onClick={() =>
          showPopup({
            position: PopupPosition.Right,
            width: 400,
            height: 400,
            path: "calendar",
          })
        }
        onDoubleClick={() => hidePopup()}
      >
        {/* time */}
        <div
          className="flex flex-row text-[12px] font-bold"
          style={{
            color: hexFromArgb(theme.onBackground),
          }}
        >
          <NumberFlowGroup>
            <NumberFlow
              format={{ minimumIntegerDigits: 2 }}
              value={time?.hour ?? 0}
              spinTiming={{
                duration: TransitionDuration.STANDARD,
                easing: TransitionCurve.STANDARD,
              }}
              digits={{ 1: { max: 2 } }}
              trend={+1}
            />
            <NumberFlow
              prefix=":"
              format={{ minimumIntegerDigits: 2 }}
              value={time?.minute ?? 0}
              spinTiming={{
                duration: TransitionDuration.STANDARD,
                easing: TransitionCurve.STANDARD,
              }}
              digits={{ 1: { max: 5 } }}
              trend={+1}
            />
            <NumberFlow
              prefix=":"
              format={{ minimumIntegerDigits: 2 }}
              value={time?.second ?? 0}
              spinTiming={{
                duration: TransitionDuration.STANDARD,
                easing: TransitionCurve.STANDARD,
              }}
              digits={{ 1: { max: 5 } }}
              trend={+1}
            />
          </NumberFlowGroup>
        </div>

        {/* date */}
        <div
          className="flex flex-row text-[10px]"
          style={{
            color: hexFromArgb(theme.onBackground),
          }}
        >
          <NumberFlowGroup>
            <NumberFlow
              format={{ minimumIntegerDigits: 2 }}
              value={time?.day ?? 0}
              spinTiming={{
                duration: TransitionDuration.STANDARD,
                easing: TransitionCurve.STANDARD,
              }}
              digits={{ 1: { max: 3 } }}
              trend={+1}
            />
            <NumberFlow
              prefix="-"
              format={{ minimumIntegerDigits: 2 }}
              value={time?.month ?? 0}
              spinTiming={{
                duration: TransitionDuration.STANDARD,
                easing: TransitionCurve.STANDARD,
              }}
              digits={{ 1: { max: 1 } }}
              trend={+1}
            />
            <NumberFlow
              prefix="-"
              format={{ minimumIntegerDigits: 2, useGrouping: false }}
              value={time?.year ?? 0}
              spinTiming={{
                duration: TransitionDuration.STANDARD,
                easing: TransitionCurve.STANDARD,
              }}
              trend={+1}
            />
          </NumberFlowGroup>
        </div>
      </div>
    );
  }
}
