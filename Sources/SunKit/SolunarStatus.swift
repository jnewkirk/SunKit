struct SolunarStatus: Sendable {
    public let magicHour: MagicHour?
    public let moonIllumination: Double
    public let moonPhase: LunarPhase
    public let moonState: MoonState
    public let solarState: SolarState
}
