//
//  ViewController.swift
//  InputOutputPractice
//
//  Created by 강조은 on 2024/01/19.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var computerLabel: UILabel!
    
    @IBOutlet weak var scissorsButton: UIButton!
    @IBOutlet weak var rockButton: UIButton!
    @IBOutlet weak var paperButton: UIButton!
    
    private let viewModel = ViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = ViewModel.Input(scissorsButtonTap: scissorsButton.rx.tap,
                                    rockButtonTap: rockButton.rx.tap,
                                    paperButtonTap: paperButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.result
            .drive(resultLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.computerResult
            .drive(computerLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

