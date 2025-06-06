#include "ui.h"

#define MAPSIZEX 800
#define MAPSIZEY 720
#define MAPX 0
#define MAPY 0

#define MENUSIZEX 70
#define MENUSIZEY 50
#define MENUX 242
#define MENUY 650
#define MENUSPACE 80

#define CELLSIZEX 50
#define CELLSIZEY 50
#define CELLX 125
#define CELLY 50

#define SPACING 55

#define CELLNUMBER 10

UI::UI() : stop(false), quit(false), loaded(false), play(false) {}

void UI::run(){
    load_game();
}

void UI::load_game(){
    frame = new Fl_Window(MAPSIZEX, MAPSIZEY, "Conway 2");
    background = new Fl_Box(MAPX, MAPY, MAPSIZEX, MAPSIZEY);
    background->box(FL_FLAT_BOX);
    background->color(FL_BLACK);

    for(int i = 0; i < CELLNUMBER; ++i){
        for(int j = 0; j < CELLNUMBER; ++j){
            Fl_Button* cell = new Fl_Button(CELLX + (SPACING * i), CELLY + (SPACING * j), CELLSIZEX, CELLSIZEY);
            cell->box(FL_FLAT_BOX);
            cell->clear_visible_focus();
            cell->color(fl_rgb_color(60, 60, 60));
            cells.push_back(cell);
        }
    }

    esc = new Fl_Button(MENUX, MENUY, MENUSIZEX, MENUSIZEY, "EXIT");
    esc->box(FL_FLAT_BOX);
    esc->color(FL_WHITE);
    esc->callback(quit_game, this);
    esc->clear_visible_focus();

    start = new Fl_Button(MENUX + MENUSPACE, MENUY, MENUSIZEX, MENUSIZEY, "START");
    start->box(FL_FLAT_BOX);
    start->color(FL_WHITE);
    start->callback(start_game, this);
    start->clear_visible_focus();

    pause = new Fl_Button(MENUX + (MENUSPACE * 2), MENUY, MENUSIZEX, MENUSIZEY, "PAUSE");
    pause->box(FL_FLAT_BOX);
    pause->color(FL_WHITE);
    pause->callback(pause_game, this);
    pause->clear_visible_focus();

    load = new Fl_Button(MENUX + (MENUSPACE * 3), MENUY, MENUSIZEX, MENUSIZEY, "LOAD");
    load->box(FL_FLAT_BOX);
    load->color(FL_WHITE);
    load->callback(load_grid, this);
    load->clear_visible_focus();

    
}



void UI::iterate(){
    
    if(!loaded && play){
        loaded = true;

        //CARGAR EL GRID DEL BACK, EJEMPLO:

        for(int i = 0; i < CELLNUMBER - 5; ++i){           // <--- INDICA CUALES PONER AMARILAS, SE PUEDE HACER UN IF PARA DEFINIR ENTRE AMARILLO Y GRIS
            for(int j = 0; j < CELLNUMBER - 5; ++j){
                int index = i * CELLNUMBER + j;
                

                                                        //<---- EL IF IRIA EN ESTA LINEA


                //LA MATRIZ SE RECORRE COMO UNA LISTA 
                cells[index]->color(FL_YELLOW);



            }
        }

    } else if(loaded && play){

        //METER LA MATRIZ DE 100 NUMEROS DEL BACK Y MODIFICAR LOS COLORES: AMARILLO PARA 1 Y GRIS PARA 0

    }
    frame->redraw();
}



void UI::load_grid(Fl_Widget* w, void* user_data){
    UI* game = static_cast<UI*>(user_data);
    game->loaded = false;
}

void UI::pause_game(Fl_Widget* w, void* user_data){
    UI* game = static_cast<UI*>(user_data);
    game->stop = true;
}


void UI::start_game(Fl_Widget* w, void* user_data){
    UI* game = static_cast<UI*>(user_data);
    game->play = true;
    game->stop = false;
}

void UI::quit_game(Fl_Widget* w, void* user_data){
    UI* game = static_cast<UI*>(user_data);
    game->stop = true;
    game->quit = true;
    game->play = false;
}

bool UI::get_quit(){
    return quit;
}

bool UI::get_start(){
    return play;
}

bool UI::get_pause(){
    return stop;
}

void UI::show(){
    frame->show();
}
void UI::hide(){
    frame->hide();
}

UI::~UI(){

}