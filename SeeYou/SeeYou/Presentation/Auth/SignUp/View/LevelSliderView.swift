//
//  LevelSliderView.swift
//  SeeYou
//
//  Created by 배남석 on 6/12/24.
//

import UIKit

protocol SliderViewDelegate: AnyObject {
    func sliderView(_ sender: LevelSliderView, changedValue value: Int)
}

final class LevelSliderView: UIView {
    
    //MARK: - Properties
    private let trackView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.Palette.gray200.cgColor
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var thumbView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.Palette.primary500.cgColor
        view.isUserInteractionEnabled = true
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(gesture)
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = .init(width: 3, height: 3)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.8
        return view
    }()
    
    private let fillTrackView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.Palette.primary500.cgColor
        view.layer.cornerRadius = 4
        return view
    }()
    
    private var dividers: [UIView] = []
    
    private var maxValue: Int
    private var touchBeganPosX: CGFloat?
    private var didLayoutSubViews: Bool = false
    
    private let thumbSize: CGFloat = 20
    private let dividerWidth: CGFloat = 1
    private let dividerHeight: CGFloat = 6
    
    weak var delegate: SliderViewDelegate?
    
    override var intrinsicContentSize: CGSize {
        return .init(width: .zero, height: thumbSize)
    }
    
    var value: Int = 1 {
        didSet {
            delegate?.sliderView(self, changedValue: value)
        }
    }
    
    //MARK: - LifeCycle
    init(maxValue: Int) {
        if maxValue < 1 {
            self.maxValue = 1
        }
        else if maxValue > 5 {
            self.maxValue = 5
        }
        else{
            self.maxValue = maxValue
        }
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !didLayoutSubViews {
            makeDivider(maxValue)
            dividers[0].backgroundColor = .Palette.primary500
            thumbView.layer.cornerRadius = thumbView.frame.width / 2
            thumbView.layer.shadowPath = UIBezierPath(
                roundedRect: thumbView.bounds,
                cornerRadius: thumbView.layer.cornerRadius
            ).cgPath
        }
    }
    
    //MARK: - Helpers
    private func layout() {
        [trackView, fillTrackView, thumbView].forEach(addSubview)
        
        trackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(8)
        }
        thumbView.snp.makeConstraints {
            $0.centerY.equalTo(trackView)
            $0.leading.equalTo(trackView).offset(-(thumbSize / 2))
            $0.size.equalTo(thumbSize)
        }
        fillTrackView.snp.makeConstraints {
            $0.leading.equalTo(trackView)
            $0.top.bottom.equalTo(trackView)
            $0.width.equalTo(0)
        }
    }
    
    private func makeDivider(_ numberOfDivider: Int) {
        let slicedPosX = trackView.frame.width / CGFloat(numberOfDivider - 1)
        
        for i in 0..<numberOfDivider {
            let dividerPosX = slicedPosX * CGFloat(i)
            let divider = makeDivider()
            let dividerLabel = makeDividerLabel(SYText.LanguageLevelType(index: i)?.toName() ?? "오류")
            
            trackView.addSubview(divider)
            trackView.addSubview(dividerLabel)
            divider.snp.makeConstraints {
                $0.top.equalTo(trackView.snp.bottom).offset(14)
                $0.leading.equalTo(trackView).offset(dividerPosX)
                $0.width.equalTo(dividerWidth)
                $0.height.equalTo(dividerHeight)
            }
            
            dividerLabel.snp.makeConstraints {
                $0.top.equalTo(divider.snp.bottom).offset(2)
                $0.centerX.equalTo(divider.snp.centerX)
            }
        }
        
        didLayoutSubViews.toggle()
    }
    
    private func makeDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = .Palette.gray400
        divider.clipsToBounds = true
        divider.layer.cornerRadius = 1
        dividers.append(divider)
        return divider
    }
    
    private func makeDividerLabel(_ text: String) -> UIView {
        let label = UILabel()
        label.sizeToFit()
        label.text = text
        label.textAlignment = .center
        label.textColor = .Palette.gray700
        label.font = .systemFont(ofSize: 12)
        
        return label
    }
    
    //MARK: - Actions
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: thumbView)
        
        if recognizer.state == .began {
            touchBeganPosX = thumbView.frame.minX
        }
        if recognizer.state == .changed {
            guard let startX = self.touchBeganPosX else { return }
            
            var offSet = startX + translation.x
            if offSet < 0 || offSet > trackView.frame.width { return }
            let slicedPosX = trackView.frame.width / CGFloat(maxValue - 1)
            
            let newValue = round(offSet / slicedPosX)
            offSet = slicedPosX * newValue - (thumbSize / 2)
            
            thumbView.snp.updateConstraints { make in
                make.leading.equalTo(trackView).offset(offSet)
            }
            fillTrackView.snp.updateConstraints { make in
                make.width.equalTo(offSet)
            }
            
            if value != Int(newValue + 1) {
                value = Int(newValue + 1)
                for i in 0..<value {
                    dividers[i].backgroundColor = .Palette.primary500
                }
                for i in value..<maxValue {
                    dividers[i].backgroundColor = .Palette.gray400
                }
            }
        }
    }

}
