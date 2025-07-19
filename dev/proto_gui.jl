using GLMakie

"""
    gui()
Makes the game GUI that dispays the current positions of each robot and strats for each team

Arguments
    - Nothing

Returns:
    - `fig::Figure`: the GLMakie Figure object for the GUI
    - `map::Axis`: the GLMakie Axis Object that maps the robot positions

"""
function gui()
    # Create the main screen
    fig = Figure(size=(800, 600), title="ROBOT TAG PROTOTYPE GUI")
    map = Axis(fig[1:2, 1], title="BATTLE FEILD", aspect=1)
    hidedecorations!(map)
    hidespines!(map)
    xs = -80:80

    # team personalization consts
    team1_name = "Blue"
    team2_name = "Red"
    team1_color = :midnightblue
    team2_color = :crimson
    team1_slogan = "Let's go team $(team1_name)!"
    team2_slogan = "WE WILL CRUSH THEM!"
    entangler_symbol = :circle
    ranger_symbol = :utriangle
    tank_symbol = :diamond
    bot_marker_size = 20

    # Create the strat screens
    strat_fig1 = Figure(size=(400, 400), title = "Team 1 Strats!")
    strat_fig2 = Figure(size=(400,400), title = "Team 2 Strats")

    Label(strat_fig1[1, 1], text=team1_slogan, color=team1_color, font=:bold)
    Label(strat_fig2[1, 1], text=team2_slogan, color=team2_color, font=:bold)

    pos_box1 = GridLayout(strat_fig1[2, 1])
    Label(pos_box1[1, 1], text="Estimated Robot Positions", font = :bold)
    est_pos_entangler1 = Label(pos_box1[2, 1], text="Entangler: ", halign = :left,)
    est_pos_ranger1 = Label(pos_box1[3, 1], text="Ranger: ", halign = :left,)
    est_pos_tank1 = Label(pos_box1[4, 1], text="Tank: ", halign = :left,)

    pos_box2 = GridLayout(strat_fig2[2, 1])
    Label(pos_box2[1, 1], text="Estimated Robot Positions", font = :bold)
    est_pos_entangler2 = Label(pos_box2[2, 1], text="Entangler: ", halign = :left,)
    est_pos_ranger2 = Label(pos_box2[3, 1], text="Ranger: ", halign = :left,)
    est_pos_tank2 = Label(pos_box2[4, 1], text="Tank: ", halign = :left,)


    is_running::Bool = true
    
    entangler1_xpos = Observable{Int32}(-50)
    entangler1_ypos = Observable{Int32}(50)

    entangler2_xpos = Observable{Int32}(-50)
    entangler2_ypos = Observable{Int32}(-50)

    ranger1_xpos = Observable{Int32}(0)
    ranger1_ypos = Observable{Int32}(50)

    ranger2_xpos = Observable{Int32}(0)
    ranger2_ypos = Observable{Int32}(-50)

    tank1_xpos = Observable{Int32}(50)
    tank1_ypos = Observable{Int32}(50)

    tank2_xpos = Observable{Int32}(50)
    tank2_ypos = Observable{Int32}(-50)

    # draw the bounds for the team sides
    band!(map, xs, 0, 60, color=(team1_color, 0.2))
    band!(map, xs, -60, 0, color=(team2_color, 0.2))

    # mark team 1 positions on map
    scatter!(
        map, 
        entangler1_xpos, 
        entangler1_ypos, 
        color=team1_color, 
        markersize=bot_marker_size, 
        marker=entangler_symbol,
        label = "Team $team1_name: Entangler"
    )
    scatter!(
        map, 
        ranger1_xpos, 
        ranger1_ypos, 
        color=team1_color, 
        markersize=bot_marker_size, 
        marker=ranger_symbol,
        label = "Team $team1_name: Ranger"
    )
    scatter!(
        map, 
        tank1_xpos, 
        tank1_ypos, 
        color=team1_color, 
        markersize=bot_marker_size, 
        marker=tank_symbol,
        label = "Team $team1_name: Tank"
    )
    #mark team 2 positions on map
    scatter!(
        map, 
        entangler2_xpos, 
        entangler2_ypos, 
        color=team2_color, 
        markersize=bot_marker_size, 
        marker=entangler_symbol,
        label = "Team $team2_name: Entangler"
    )
    scatter!(
        map, 
        ranger2_xpos, 
        ranger2_ypos, 
        color=team2_color, 
        markersize=bot_marker_size, 
        marker=ranger_symbol,
        label = "Team $team2_name: Ranger"
    )
    scatter!(
        map, 
        tank2_xpos, 
        tank2_ypos, 
        color=team2_color, 
        markersize=bot_marker_size, 
        marker=tank_symbol,
        label = "Team $team2_name: Tank"
    )

    Legend(fig[1, 2], map, "Key", framevisible = false)

    @async begin
        while is_running
            # Update estimated positions on each teams strat gui
            est_pos_entangler1.text = "Entangler: ($(entangler1_xpos[]), $(entangler1_ypos[]))"
            est_pos_ranger1.text = "Ranger: ($(ranger1_xpos[]), $(ranger1_ypos[]))"
            est_pos_tank1.text = "Tank: ($(tank1_xpos[]), $(tank1_ypos[]))"

            est_pos_entangler2.text = "Entangler: ($(entangler2_xpos[]), $(entangler2_ypos[]))"
            est_pos_ranger2.text = "Ranger: ($(ranger2_xpos[]), $(ranger2_ypos[]))"
            est_pos_tank2.text = "Tank: ($(tank2_xpos[]), $(tank2_ypos[]))"

        sleep(0.1) # yeild time
        end
    end
    
    is_running = close_window(fig)

    display(GLMakie.Screen(), fig)
    display(GLMakie.Screen(), strat_fig1)
    display(GLMakie.Screen(), strat_fig2)

    return fig, map
end

function close_window(fig, cleanups...)
    on(events(fig).window_open) do is_open
        if !is_open
            @info "Closing window"
            for func in cleanups
                try
                    func()
                catch e
                    @error "Error: $e"
                end
            end
            GLMakie.closeall()
            return false
        end
    end
end

gui()