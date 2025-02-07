// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

class RecursiveGridView: UIView {
    var spacing: CGFloat = 8 { didSet { setNeedsLayout() }}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let subviewCount = subviews.count
        guard subviewCount > 0 else { return }
        
        // Calculate the optimal row count and direction first
        let (rowCount, isHorizontal) = calculateOptimalRowsAndDirection(for: subviewCount)
        let spacing: CGFloat = 8
        
        // Calculate equal row sizes
        let availableSpace = isHorizontal ? bounds.height : bounds.width
        let totalSpacing = spacing * CGFloat(rowCount - 1)
        let rowSize = (availableSpace - totalSpacing) / CGFloat(rowCount)
        
        // Distribute views among rows
        let viewsPerRow = (0..<rowCount).map { row in
            let startIndex = (subviewCount * row) / rowCount
            let endIndex = (subviewCount * (row + 1)) / rowCount
            return endIndex - startIndex
        }
        
        // Layout each row
        var currentIndex = 0
        for (rowIndex, viewCount) in viewsPerRow.enumerated() {
            let rowRect: CGRect
            if isHorizontal {
                // Horizontal layout - rows stacked vertically
                let yPosition = bounds.minY + (rowSize + spacing) * CGFloat(rowIndex)
                rowRect = CGRect(x: bounds.minX,
                               y: yPosition,
                               width: bounds.width,
                               height: rowSize)
            } else {
                // Vertical layout - rows stacked horizontally
                let xPosition = bounds.minX + (rowSize + spacing) * CGFloat(rowIndex)
                rowRect = CGRect(x: xPosition,
                               y: bounds.minY,
                               width: rowSize,
                               height: bounds.height)
            }
            
            layoutRow(rowRect, startIndex: currentIndex, count: viewCount)
            currentIndex += viewCount
        }
    }
    
    private func calculateOptimalRowsAndDirection(for count: Int) -> (rows: Int, isHorizontal: Bool) {
        let isHorizontal = bounds.width >= bounds.height
        
        if count <= 3 {
            return (1, isHorizontal)
        }
        
        // Calculate optimal number of rows based on the count
        let rowCount = Int(ceil(sqrt(Double(count))))
        return (rowCount, isHorizontal)
    }
    
    private func layoutRow(_ rect: CGRect, startIndex: Int, count: Int) {
        let spacing: CGFloat = 8
        let isHorizontal = rect.width >= rect.height
        
        if isHorizontal {
            // Layout items horizontally within the row
            let itemWidth = (rect.width - (spacing * CGFloat(count - 1))) / CGFloat(count)
            for i in 0..<count {
                let view = subviews[startIndex + i]
                let xOffset = rect.minX + (itemWidth + spacing) * CGFloat(i)
                view.frame = CGRect(x: xOffset,
                                  y: rect.minY,
                                  width: itemWidth,
                                  height: rect.height)
            }
        } else {
            // Layout items vertically within the row
            let itemHeight = (rect.height - (spacing * CGFloat(count - 1))) / CGFloat(count)
            for i in 0..<count {
                let view = subviews[startIndex + i]
                let yOffset = rect.minY + (itemHeight + spacing) * CGFloat(i)
                view.frame = CGRect(x: rect.minX,
                                  y: yOffset,
                                  width: rect.width,
                                  height: itemHeight)
            }
        }
    }
}
