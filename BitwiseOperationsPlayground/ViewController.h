//
//  ViewController.h
//  BitwiseOperationsPlayground
//
//  Created by Xcode Developer on 1/2/22.
//

#import <UIKit/UIKit.h>
@import Accelerate;

#include <limits.h>        /* for CHAR_BIT */
#include <stdio.h>
#include <string.h>


/*
 
 (If you don't have <limits.h>, try using 8 for CHAR_BIT.)
 Here are some usage examples.
 
 To declare an ``array'' of 47 bits:
 char bitarray[BITNSLOTS(47)];
 To set the 23rd bit:
 BITSET(bitarray, 23);
 To test the 35th bit:
 if(BITTEST(bitarray, 35)) ...
 To compute the union of two bit arrays and place it in a third array (with all three arrays declared as above):
 for(i = 0; i < BITNSLOTS(47); i++)
 array3[i] = array1[i] | array2[i];
 To compute the intersection, use & instead of |.
 As a more realistic example, here is a quick implementation of the Sieve of Eratosthenes, for computing prime numbers:
 
 #include <stdio.h>
 #include <string.h>
 */


//#define PROPERTY_COUNT 5
//#define BIT_COUNT      15
//
//static void (^init_property_bit_array)(void) = ^{
//    char bit_array[BITNSLOTS(PROPERTY_COUNT)][BITNSLOTS(PROPERTY_COUNT)][BITNSLOTS(PROPERTY_COUNT)];
//    char property[BITNSLOTS(PROPERTY_COUNT)];
//    char selected[BITNSLOTS(PROPERTY_COUNT)];
//    char hidden[BITNSLOTS(PROPERTY_COUNT)];
//    
//    memset(bit_array, 0, BITNSLOTS(BIT_COUNT));
//    memset(property, 0, BITNSLOTS(BIT_COUNT));
//    memset(selected, 0, BITNSLOTS(BIT_COUNT));
//    memset(hidden, 0, BITNSLOTS(BIT_COUNT));
//    
//    for(i = 2; i < MAX; i++) {
//        if(!BITTEST(bitarray, i)) {
//            printf("%d\n", i);
//            for(j = i + i; j < MAX; j += i)
//                BITSET(bitarray, j);
//        }
//    }
//    return 0;
//}
//
//};
    
@interface ViewController : UIViewController


@end

