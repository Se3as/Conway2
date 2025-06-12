#include "ui.h"
#include <chrono> 
#include <thread> 

using namespace std;

int main() {
    UI conway;
    conway.run();
    conway.show();

    while(!conway.get_start()){
        Fl::wait();
    }

    auto last_time = chrono::steady_clock::now();
    const chrono::milliseconds interval(1000); // 1 segundo

    while(!conway.get_quit() && conway.get_start()){

        auto current_time = chrono::steady_clock::now();
        auto elapsed = current_time - last_time;

        if(elapsed >= interval){
            conway.iterate(); 
            last_time = current_time; 
            
        
            static int seconds = 0;
            cout << "Tick: " << ++seconds << endl;
        }

        while(conway.get_pause()){
            Fl::wait();

            if(conway.get_quit()){
                break;
            }
        }
        
        Fl::wait(0.01); 
    }


    if(conway.get_quit()){
        conway.hide();
        cout << "Game ended." << std::endl;
        Fl::check();
    }

    return 0;
}