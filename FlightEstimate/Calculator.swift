//
//  Calculator.swift
//  FlightEstimate
//
//  Created by richard Haynes on 11/23/24.
//
fileprivate func power(weight: Double) -> Double {
    let maxAssumedWhattsPerGram: Double = 35
    let minAssumedWhattsPerGram: Double = 25
    let gramsToHover: Double = 100
    let maxEstimateOfPowerToHover = weight * (maxAssumedWhattsPerGram/gramsToHover)
    let minEstimateOfPowerToHover = weight * (minAssumedWhattsPerGram/gramsToHover)
    let combined = maxEstimateOfPowerToHover + minEstimateOfPowerToHover
    return (combined) / 2
}
func Calculate(windSpeed: Double, BatteryLevel: Double, Weight: Double) -> String{
    let power = power(weight: Weight)
    let weigtherFactor = 1 + (windSpeed * 0.05)
    let adjustedCurrent = power * weigtherFactor
    let minutes = (BatteryLevel / adjustedCurrent) * 60
    return String(format: "%.2f", minutes)
}
