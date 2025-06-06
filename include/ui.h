#pragma once

#include <iostream>
#include <unordered_map>
#include <vector>
#include <random>
#include <filesystem>

#include <FL/Fl.H>
#include <Fl/Fl_Window.H>
#include <Fl/Fl_Button.H>
#include <FL/Fl_PNG_Image.H>
#include <Fl/Fl_Box.H>
#include <FL/Fl_Multiline_Output.H>
#include <FL/fl_draw.H>
#include <FL/fl_ask.H>

using namespace std;

class UI {

private:
    Fl_Window* frame;
    Fl_Box* background;

    Fl_Button* esc;
    Fl_Button* pause;
    Fl_Button* start;
    Fl_Button* load;

    vector<Fl_Button*> cells;

    bool stop;
    bool quit;
    bool loaded;
    bool play;

    

public:
    UI();
    ~UI();

    void show();
    void hide();

    void run();

    void load_game();

    static void load_grid(Fl_Widget* w, void* user_data);

    static void pause_game(Fl_Widget* w, void* user_data);

    static void start_game(Fl_Widget* w, void* user_data);

    static void quit_game(Fl_Widget* w, void* user_data);

    bool get_quit();

    bool get_start();

    bool get_pause();

    void iterate();

};