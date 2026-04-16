return {
    notify = {
        route_started = 'Route started: %s',
        route_completed = 'Route completed! Reward: $%s',
        route_cancelled = 'Route has been cancelled.',
        not_in_bus = 'You are not in a bus.',
        wrong_vehicle = 'This is not an allowed bus vehicle.',
        already_on_route = 'You are already on a route.',
        no_route_active = 'No active route.',

        payment_card_success = 'Card payment accepted: $%s',
        payment_card_failed = 'Card payment failed - retrying...',
        payment_cash_received = 'Cash received: $%s',
        payment_change_given = 'Change returned: $%s',
        payment_change_correct = 'Correct change returned!',
        payment_change_wrong = 'Wrong change! (Needed: $%s, Given: $%s)',
        payment_change_timeout = 'Change return timed out!',
        payment_tip_received = 'Tip received: $%s',
        payment_underpay = 'Insufficient fare. ($%s / $%s)',

        arriving_stop = 'Next stop: %s',
        arrived_stop = 'Arrived at: %s',
        lap_started = 'Lap %s/%s started!',
        passengers_boarding = '%s passenger(s) boarding.',
        passengers_alighting = '%s passenger(s) alighting.',
        waiting_passengers = 'Waiting for passenger payment...',
        all_boarded = 'All passengers boarded.',
        last_stop_no_boarding = 'Last stop — no passengers boarding.',
        missed_stop = 'You missed a stop!',

        business_created = 'Bus company "%s" has been established!',
        business_exists = 'You already own a bus company.',
        business_no_money = 'Insufficient funds. (Required: $%s)',
        level_up = 'You reached Level %s!',
        business_level_up = 'Company level up! (Lv.%s)',
        employee_hired = '%s has been hired.',
        employee_fired = '%s has been fired.',
        employee_max = 'Maximum employees reached.',
        employee_salary_paid = 'Employee salary paid: $%s',

        error_generic = 'An error occurred.',
        error_database = 'A database error occurred.',
        error_no_permission = 'No permission.',

        -- Dispatch & Bus
        bus_already_dispatched = 'You already have a bus dispatched.',
        spawn_blocked = 'Spawn point is blocked. Please clear the area.',
        model_load_failed = 'Failed to load bus model.',
        bus_dispatched_key = 'Bus dispatched! Board the bus and select a route with %s.',
        bus_dispatched_auto = 'Bus dispatched! Board the bus and the route will start automatically.',
        bus_dispatched = 'Bus dispatched! Board the bus and press %s to select a route.',
        cannot_return_on_route = 'Cannot return bus while on a route.',
        drive_to_depot = 'Drive the bus back to the depot first.',
        bus_returned = 'Bus returned successfully.',
        route_started_drive = 'Route started! Drive to the first stop.',
        route_start_failed = 'Failed to start route.',
        invalid_selection = 'Invalid selection.',
        invalid_bus_model = 'Invalid bus model.',
        must_be_in_bus = 'You must be in your dispatched bus.',
        not_in_dispatched_bus = 'You must be inside your dispatched bus to select a route.',

        -- Route completion & Depot return
        all_stops_completed = 'All stops completed! Return to the bus depot to finish.',
        bus_parked_earnings = 'Bus parked. Earnings deposited!',

        -- Server
        route_requires_company = 'This route requires a bus company.',
        level_up_title = 'Level Up!',
        already_employed = 'Already employed at another company.',

        -- Driving Rating
        rating_hard_brake = '⚠ Hard braking detected!',
        rating_collision = '⚠ Collision detected!',
        rating_speeding = '⚠ Speeding! %s km/h',
        rating_red_light = '⚠ Ran a red light!',
        rating_star_lost = '★ Rating dropped to %s stars',

        -- Daily Challenges
        challenge_claimed_title = 'Challenge Complete!',
        challenge_claimed = 'Reward received: $%s',

        -- Bus Condition
        fuel_low = 'Fuel is getting low!',
        fuel_critical = 'Fuel critically low! Refuel soon!',
        fuel_empty = 'Out of fuel! Engine has stalled.',
        engine_critical = 'Engine severely damaged! Speed reduced.',
        maintenance_title = 'Maintenance',
        maintenance_cost = 'Total: $%s — ',
        repair_detail = 'Repair: $%s (%s%% damaged)',
        fuel_detail = 'Fuel: $%s',
    },

    time_period = {
        morningRush = '🌅 Morning Rush',
        daytime = '☀️ Daytime',
        eveningRush = '🌆 Evening Rush',
        evening = '🌙 Evening',
        lateNight = '🌃 Late Night',
        earlyMorning = '🌄 Early Morning',
        weekend = 'Weekend',
    },

    labels = {
        bus_system = 'Bus System',
        bus_company = 'Bus Company',
        bus_depot = 'Bus Depot',
        dashboard = 'Dashboard',
        route = 'Route',
        routes = 'Routes',
        employees = 'Employees',
        statistics = 'Statistics',
        settings = 'Settings',

        status_active = 'Active',
        status_idle = 'Idle',
        status_completed = 'Completed',
        status_cancelled = 'Cancelled',
        unknown = 'Unknown',

        card_payment = 'Card Payment',
        cash_payment = 'Cash Payment',
        fare = 'Fare',
        change = 'Change',
        tip = 'Tip',
        total = 'Total',

        next_stop = 'Next Stop',
        next_stop_blip = 'Next Stop: %s',
        current_stop = 'Current Stop',
        passengers = 'Passengers',
        zone = 'Zone',

        -- ox_target
        get_a_bus = 'Get a Bus',
        return_bus = 'Return Bus',
        management_label = 'Bus Company Management',
        dispatch_label = 'Bus Dispatch',

        -- Blip / HUD
        return_to_depot = 'Return to Depot',
        return_to_depot_route = '%s - Return to Depot',

        -- Commands
        open_routes_desc = 'Open route selection (while in bus)',
        cancel_route_desc = 'Cancel current route',

        -- Business levels
        level_newcomer = 'Newcomer',
        level_growing = 'Growing',
        level_established = 'Established',
        level_major = 'Major',
        level_premium = 'Premium',

        -- Bus types
        bus_city = 'City Bus',
        bus_airport = 'Airport Shuttle',
        bus_luxury = 'Luxury Coach',
    },

    menu = {
        open_dashboard = 'Open Dashboard',
        start_route = 'Start Route',
        select_route = 'Select Route',
        manage_employees = 'Manage Employees',
        view_statistics = 'View Statistics',
        create_business = 'Create Business',
        close = 'Close',
    },

    status = {
        on_route = '🚌 On Route',
        idle = '⏸️ Idle',
        boarding = '🚶 Boarding',
        payment = '💳 Processing Payment',
        change = '💰 Returning Change',
        driving = '🛣️ Driving',
    },

    prompts = {
        enter_bus = '[E] Enter Bus',
        open_dashboard = '[%s] Dashboard',
        interact_payment = '[E] Return Change',
        next_denomination = '[←/→] Select Amount | [E] Return | [Backspace] Cancel',
    },

    event = {
        -- Fare Evader
        fare_evader_title = 'Fare Evader',
        fare_evader_desc = 'A passenger is trying to board without paying!',
        fare_evader_report = 'Report',
        fare_evader_ignore = 'Ignore',
        fare_evader_reported = 'Fare evader reported! Bonus: $%s',
        fare_evader_ignored = 'You let them go.',

        -- Drunk Passenger
        drunk_title = 'Drunk Passenger',
        drunk_desc = 'A drunk passenger is causing a disturbance!',
        drunk_kick = 'Kick Off',
        drunk_tolerate = 'Tolerate',
        drunk_kicked = 'Drunk passenger removed.',
        drunk_tolerated = 'The drunk passenger stumbled on...',

        -- Sick Passenger
        sick_title = 'Sick Passenger',
        sick_desc = 'A passenger is feeling unwell and needs help!',
        sick_hospital = 'Emergency Detour ($%s bonus)',
        sick_continue = 'Continue Route',
        sick_detour = 'Drive to the hospital! Bonus on arrival.',
        sick_detour_hud = 'Emergency Detour',
        sick_blip = 'Pillbox Hospital',
        sick_continued = 'Continuing route...',
        sick_arrived = 'Patient delivered! Bonus: $%s',

        -- VIP Pickup
        vip_title = 'VIP Request',
        vip_desc = 'A VIP passenger wants to board at this stop!',
        vip_accept = 'Accept ($%s bonus)',
        vip_decline = 'Decline',
        vip_accepted = 'VIP boarded! Bonus: $%s',
        vip_declined = 'VIP request declined.',
    },

    -- Dashboard UI
    dashboard = {
        tabRoutes = 'Routes',
        tabChallenges = 'Challenges',
        levelRequired = 'Requires Lv.%s',
        inService = 'In Service',
    },

    -- Daily Challenges
    challenges = {
        dailyTitle = 'Daily Challenges',
        resetsIn = 'Resets daily',
        claim = 'Claim',
        noChallenges = 'No challenges available.',

        -- Difficulty labels
        easy = 'Easy',
        medium = 'Medium',
        hard = 'Hard',

        -- Challenge type labels (%s = target number)
        typeTrips = 'Complete %s route(s)',
        typePassengers = 'Transport %s passenger(s)',
        typeEarnings = 'Earn $%s',
        typePerfectRating = 'Get %s perfect 5-star rating(s)',
        typeLaps = 'Complete %s lap(s)',
    },
}
