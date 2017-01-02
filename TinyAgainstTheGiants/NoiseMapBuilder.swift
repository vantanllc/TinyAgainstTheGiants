//
//  NoiseMap.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/1/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

class NoiseMapBuilder {
  static func getPerlinNoiseMap(frequency: Double) -> GKNoiseMap {
    let noise = getPerlinNoise(frequency: frequency)
    return GKNoiseMap(noise)
  }
  
  static func getPerlinNoise(frequency: Double, octaveCount: Int = 6, persistence: Double = 0.5, lacunarity: Double = 2.0) -> GKNoise {
    let seed: Int32 = Int32(GKRandomSource.sharedRandom().nextInt())
    let noiseSource = GKPerlinNoiseSource(frequency: frequency, octaveCount: octaveCount, persistence: persistence, lacunarity: lacunarity, seed: seed)
    return GKNoise(noiseSource)
  }
  
  static func getCheckerboardNoiseMap(squareSize: Double) -> GKNoiseMap {
    let noise = getCheckerboardNoise(squareSize: squareSize)
    return GKNoiseMap(noise)
  }
  
  static func getCheckerboardNoise(squareSize: Double) -> GKNoise {
    let noiseSource = GKCheckerboardNoiseSource(squareSize: squareSize)
    return GKNoise(noiseSource)
  }
  
  static func getCheckerboardPerlinNoiseMap(squareSize: Double, frequency: Double) -> GKNoiseMap {
    let checkerboardNoise = getCheckerboardNoise(squareSize: squareSize)
    let perlinNoise = getPerlinNoise(frequency: frequency)
    let combinedNoise = GKNoise(componentNoises: [checkerboardNoise, perlinNoise],
                                selectionNoise: perlinNoise)
    return GKNoiseMap(combinedNoise)
  }
}
