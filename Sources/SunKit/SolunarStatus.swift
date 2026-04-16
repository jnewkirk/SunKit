struct SolunarStatus: Sendable {
    public let magicHour: MagicHour?
    public let moonIllumination: Double
    public let moonPhase: LunarPhase
    public let moonState: LunarState
    public let solarState: SolarState
    public let galacticCenterState: LunarState
}
