// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// 8 delay line stereo FDN reverb, with feedback matrix based upon physical
/// modeling scattering junction of 8 lossless waveguides of equal characteristic impedance.
/// 
public class CostelloReverb: NodeBase, AudioUnitContainer {

    /// Unique four-letter identifier "rvsc"
    public static let ComponentDescription = AudioComponentDescription(effect: "rvsc")

    /// Internal type of audio unit for this node
    public typealias AudioUnitType = AudioUnitBase

    /// Internal audio unit 
    public private(set) var internalAU: AudioUnitType?

    let input: Node
    override public var connections: [Node] { [input] }

    // MARK: - Parameters

    /// Specification details for feedback
    public static let feedbackDef = NodeParameterDef(
        identifier: "feedback",
        name: "Feedback",
        address: akGetParameterAddress("CostelloReverbParameterFeedback"),
        defaultValue: 0.6,
        range: 0.0 ... 1.0,
        unit: .percent,
        flags: .default)

    /// Feedback level in the range 0 to 1. 0.6 gives a good small 'live' room sound, 0.8 a small hall, and 0.9 a large hall. A setting of exactly 1 means infinite length, while higher values will make the opcode unstable.
    @Parameter(feedbackDef) public var feedback: AUValue

    /// Specification details for cutoffFrequency
    public static let cutoffFrequencyDef = NodeParameterDef(
        identifier: "cutoffFrequency",
        name: "Cutoff Frequency",
        address: akGetParameterAddress("CostelloReverbParameterCutoffFrequency"),
        defaultValue: 4_000.0,
        range: 12.0 ... 20_000.0,
        unit: .hertz,
        flags: .default)

    /// Low-pass cutoff frequency.
    @Parameter(cutoffFrequencyDef) public var cutoffFrequency: AUValue

    // MARK: - Initialization

    /// Initialize this reverb node
    ///
    /// - Parameters:
    ///   - input: Input node to process
    ///   - feedback: Feedback level in the range 0 to 1. 0.6 gives a good small 'live' room sound, 0.8 a small hall, and 0.9 a large hall. A setting of exactly 1 means infinite length, while higher values will make the opcode unstable.
    ///   - cutoffFrequency: Low-pass cutoff frequency.
    ///
    public init(
        _ input: Node,
        feedback: AUValue = feedbackDef.defaultValue,
        cutoffFrequency: AUValue = cutoffFrequencyDef.defaultValue
        ) {
        self.input = input
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AudioUnitType else {
               fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit

            self.feedback = feedback
            self.cutoffFrequency = cutoffFrequency
        }
   }
}
