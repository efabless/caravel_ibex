#include "../../../sw/n5_drv.h"
#include "../../../sw/n5_int.h"


unsigned int A[100];

void IRQ() {
    gpio_write(0x0099);        
}

#define     DELAY(n)   for(int i=0; i<n; i++)

int main(){
    // Initialization
    uart_init (0, 0);
    gpio_set_dir(0x0000);
    
    // PWM
    uart_puts (0, "PWM Test: ", 10);
    pwm_init(0, 250, 99, 5);
 	pwm_enable(0);
    DELAY(300);
    pwm_disable(0); 

    // Some Delay
    DELAY(100);

    // Flag end of test
    gpio_write(0x00A4);
    return 0;
}

