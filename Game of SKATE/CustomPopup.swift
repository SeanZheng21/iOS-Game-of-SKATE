//
//  CustomPopup.swift
//  Game of SKATE
//
//  Created by Carlistle ZHENG on 8/16/21.
//

import SwiftUI

struct CustomPopup: ViewModifier {
    let alignment: Alignment
    let direction: Direction
    let isPresented: Bool

    func body(content: Content) -> some View {
        content
            .overlay(popupContent(content))
    }

    @ViewBuilder
    private func popupContent(_ content: Content) -> some View {
        GeometryReader { geometry in
            if isPresented {
                content
                    .animation(.spring())
                    .transition(.offset(x: 0, y: direction.offset(popupFrame: geometry.frame(in: .global))))
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: alignment)
            }
        }
    }
}

extension CustomPopup {
    enum Direction {
        case top, bottom

        func offset(popupFrame: CGRect) -> CGFloat {
            switch self {
            case .top:
                let aboveScreenEdge = -popupFrame.maxY
                return aboveScreenEdge
            case .bottom:
                let belowScreenEdge = UIScreen.main.bounds.height - popupFrame.minY
                return belowScreenEdge
            }
        }
    }
}

extension View {
    func popup(
        isPresented: Bool,
        alignment: Alignment = .center,
        direction: CustomPopup.Direction = .bottom
    ) -> some View {
        return modifier(CustomPopup(alignment: alignment, direction: direction, isPresented: isPresented))
    }
}

private extension View {
    func onGlobalFrameChange(_ onChange: @escaping (CGRect) -> Void) -> some View {
        background(GeometryReader { geometry in
            Color.clear.preference(key: FramePreferenceKey.self, value: geometry.frame(in: .global))
        })
        .onPreferenceChange(FramePreferenceKey.self, perform: onChange)
    }

    func print(_ varargs: Any...) -> Self {
        Swift.print(varargs)
        return self
    }
}

private struct FramePreferenceKey: PreferenceKey {
    static let defaultValue = CGRect.zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

private extension View {
    @ViewBuilder func applyIf<T: View>(_ condition: @autoclosure () -> Bool, apply: (Self) -> T) -> some View {
        if condition() {
            apply(self)
        } else {
            self
        }
    }
}

//struct CustomPopup_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomPopup()
//    }
//}