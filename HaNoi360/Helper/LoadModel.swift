//
//  LoadModel.swift
//  HaNoi360
//
//  Created by Tuấn on 22/5/25.
//

import Foundation
import CoreML

class LoadModel {
    static let shared = LoadModel()
    
    private var cachedModel: MLModel?
    
    func loadModel() -> MLModel? {

        if let model = cachedModel {
            return model
        }

        guard let url = Bundle.main.url(forResource: "ToxicClassifier", withExtension: "mlmodelc") else {
            print("Không tìm thấy file model")
            return nil
        }

        do {
            let model = try MLModel(contentsOf: url)
            self.cachedModel = model
            return model
        } catch {
            print("Lỗi load model: \(error)")
            return nil
        }
    }
    
    func loadWordIndex() -> [String: Int] {
        guard let url = Bundle.main.url(forResource: "word_index", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Int] else {
            print("Không load được từ điển")
            return [:]
        }
        return json
    }

    func tokenize(text: String, wordIndex: [String: Int], maxLen: Int = 10) -> [Int] {
        let tokens = text.lowercased().components(separatedBy: .whitespacesAndNewlines)
        var sequence = tokens.map { wordIndex[$0] ?? 0 }

        if sequence.count < maxLen {
            sequence = Array(repeating: 0, count: maxLen - sequence.count) + sequence
        } else if sequence.count > maxLen {
            sequence = Array(sequence.suffix(maxLen))
        }

        return sequence
    }

    func toMLMultiArray(_ intArray: [Int]) -> MLMultiArray? {
        let shape: [NSNumber] = [1, NSNumber(value: intArray.count)]  // Rank 2: [1, sequence_length]

        guard let array = try? MLMultiArray(shape: shape, dataType: .int32) else {
            return nil
        }

        for (index, value) in intArray.enumerated() {
            array[[0, index] as [NSNumber]] = NSNumber(value: value)
        }

        return array
    }
    
    func predict(text: String, completion: @escaping (Bool) -> Void) {
        guard let model = loadModel() else { return }
        let wordIndex = loadWordIndex()
        let tokenized = tokenize(text: text, wordIndex: wordIndex)
        guard let inputArray = toMLMultiArray(tokenized) else { return }

        do {
            let input = try MLDictionaryFeatureProvider(dictionary: ["embedding_input": inputArray])
            let prediction = try model.prediction(from: input)
            if let result = prediction.featureValue(for: "Identity")?.multiArrayValue?[0] {
                print(result.floatValue)
                completion(result.floatValue > 0.5)
            }
        } catch {
            print("Lỗi khi predict: \(error)")
        }
    }
}
