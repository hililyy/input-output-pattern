//
//  ViewModel.swift
//  InputOutputPractice
//
//  Created by 강조은 on 2024/01/19.
//

import Foundation
import RxSwift
import RxCocoa

final class ViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()
    var userChoice = BehaviorRelay<RPSType>(value: .rock)
    var computerChoice = BehaviorRelay<RPSType>(value: .rock)
    
    struct Input {
        let scissorsButtonTap: ControlEvent<Void>
        let rockButtonTap: ControlEvent<Void>
        let paperButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let computerResult: Driver<String>
        let result: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        // 선택한 버튼으로 데이터 바인딩
        input.rockButtonTap
            .map({ return RPSType.rock })
            .bind(to: userChoice)
            .disposed(by: disposeBag)
        
        input.paperButtonTap
            .map({ return RPSType.paper })
            .bind(to: userChoice)
            .disposed(by: disposeBag)
        
        input.scissorsButtonTap
            .map({ return RPSType.scissor })
            .bind(to: userChoice)
            .disposed(by: disposeBag)
        
        // 버튼이 눌리면 컴퓨터 선택 데이터 변경
        Observable.merge(
            input.scissorsButtonTap.asObservable(),
            input.rockButtonTap.asObservable(),
            input.paperButtonTap.asObservable()
        )
        .subscribe(onNext: { [weak self] _ in
            self?.updateComputerChoice()
        })
        .disposed(by: disposeBag)
        
        // 컴퓨터 vs 나의 결과 반환
        let result = Observable.combineLatest(userChoice, computerChoice)
            .map { [weak self] (user, computer) -> String in
                guard let self else { return "" }
                return calResult(user: user,
                                 computer: computer).rawValue
            }
            .asDriver(onErrorJustReturn: "")
        
        return Output(computerResult: computerChoice
            .map { $0.description }
            .asDriver(onErrorJustReturn: ""),
                      result: result)
    }
    
    private func updateComputerChoice() {
        let randomValue = Int.random(in: 0...2)
        
        if let newChoice = RPSType(rawValue: randomValue) {
            computerChoice.accept(newChoice)
        }
    }
    
    private func calResult(user: RPSType, computer: RPSType) -> RPSResult {
        switch user {
        case .rock:
            if computer == .rock {
                return .draw
            } else if computer == .paper {
                return .win
            } else {
                return .lose
            }
            
        case .paper:
            if computer == .rock {
                return .lose
            } else if computer == .paper {
                return .draw
            } else {
                return .win
            }
            
        case .scissor:
            if computer == .rock {
                return .lose
            } else if computer == .paper {
                return .win
            } else {
                return .draw
            }
        }
    }
}

enum RPSType: Int {
    case rock
    case paper
    case scissor
    
    var description: String {
        switch self {
        case .rock:
            "주먹"
        case .paper:
            "보"
        case .scissor:
            "가위"
        }
    }
}

enum RPSResult: String {
    case win = "이겼댱"
    case lose = "졌댜"
    case draw = "비겼당"
}


