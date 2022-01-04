//
//  ViewController.m
//  BitwiseOperationsPlayground
//
//  Created by Xcode Developer on 1/2/22.
//

#import "ViewController.h"
#import <objc/runtime.h>


// Button state

typedef enum {
    ControlStateRenderPropertyComponentTransition = 1 << 0,
    ControlStateRenderPropertyComponent           = 1 << 1,
    ControlStateRenderValueComponentTransition    = 1 << 2,
    ControlStateRenderValueComponent              = 1 << 3
} ControlState;


#define ControlRendererStatePropertyComponentTransition  0b0001
#define ControlRendererStatePropertyComponent            0b0010
#define ControlRendererStateValueComponentTransition     0b0100
#define ControlRendererStateValueComponent               0b1000
#define State (ControlRendererStatePropertyComponentTransition | ControlRendererStatePropertyComponent | ControlRendererStateValueComponentTransition | ControlRendererStateValueComponent)

typedef struct __attribute__((objc_boxable)) ControlRendererState ControlRendererState;
static struct __attribute__((objc_boxable)) ControlRendererState {
    unsigned int control_renderer_state : 1 << 4 >> 3;
} controlRendererState = {
    .control_renderer_state = 0b0001
};

static unsigned int (^cycle_state)(void) = ^{
    return controlRendererState.control_renderer_state++;
};


/* Button properties
 // "In computer science, a mask or bitmask is data that is used for bitwise operations, particularly in a bit field. Using a mask, multiple bits in a byte, nibble, word etc. can be set either on, off or inverted from on to off (or vice versa) in a single bitwise operation. An additional use and meaning of Masking involves predication in Vector processing, where the bitmask is used to select which element operations in the Vector are to be executed (mask bit is enabled) and which are not (mask bit is clear)."
 */

// Common bitmask functions

/*
 
 Masking bits to 1 (OR)
 Y OR 1 = 1 and Y OR 0 = Y
 To make sure a bit is on, OR can be used with a 1.
 To leave a bit unchanged, OR is used with a 0.
 
 Example: Masking on the higher nibble (bits 4, 5, 6, 7) the lower nibble (bits 0, 1, 2, 3) unchanged.
 
 10010101   10100101
 OR 11110000   11110000
 = 11110101   11110101
 
 */

/*
 
 Masking bits to 0 only (AND) - Bits are "masked off" (or masked to 0) versus "masked on" (or masked to 1)
 Y AND 0 = 0 and Y AND 1 = Y
 0 has precendence, regardless of Y.
 To leave the other bits as they were originally, use AND with 1
 
 Example: Masking off the higher nibble (bits 4, 5, 6, 7) the lower nibble (bits 0, 1, 2, 3) unchanged.
 
 10010101   10100101
 AND 00001111   00001111
 = 00000101   00000101
 
 */

/*
 
 Querying the status of a bit
 It is possible to use bitmasks to easily check the state of individual bits regardless of the other bits. To do this, turning off all the other bits using the bitwise AND is done as discussed above and the value is compared with 0. If it is equal to 0, then the bit was off, but if the value is any other value, then the bit was on. What makes this convenient is that it is not necessary to figure out what the value actually is, just that it is not 0.
 
 Example: Querying the status of the 4th bit
 
 10011101   10010101
 AND 00001000   00001000
 = 00001000   00000000
 
 */

/*
 
 Toggling bit values
 So far the article has covered how to turn bits on and turn bits off, but not both at once. Sometimes it does not really matter what the value is, but it must be made the opposite of what it currently is. This can be achieved using the XOR (exclusive or) operation. XOR returns 1 if and only if an odd number of bits are 1. Therefore, if two corresponding bits are 1, the result will be a 0, but if only one of them is 1, the result will be 1. Therefore inversion of the values of bits is done by XORing them with a 1. If the original bit was 1, it returns 1 XOR 1 = 0. If the original bit was 0 it returns 0 XOR 1 = 1. Also note that XOR masking is bit-safe, meaning that it will not affect unmasked bits because Y XOR 0 = Y, just like an OR.
 
 Example: Toggling bit values
 
 10011101   10010101
 XOR 00001111   11111111
 = 10010010   01101010
 
 */

/*
 
 To write arbitrary 1s and 0s to a subset of bits, first write 0s to that subset, then set the high bits:
 
 register = (register & ~bitmask) | value;
 
 */

typedef NS_OPTIONS(uint8_t, CaptureDeviceConfigurationControlPropertyBit) {
    CaptureDeviceConfigurationControlPropertyBitTorchLevel       = 1 << 0,
    CaptureDeviceConfigurationControlPropertyBitLensPosition     = 1 << 1,
    CaptureDeviceConfigurationControlPropertyBitExposureDuration = 1 << 2,
    CaptureDeviceConfigurationControlPropertyBitISO              = 1 << 3,
    CaptureDeviceConfigurationControlPropertyBitZoomFactor       = 1 << 4,
};

typedef CaptureDeviceConfigurationControlPropertyBit               CaptureDeviceConfigurationControlPropertyBitMask;
typedef CaptureDeviceConfigurationControlPropertyBitMask           CaptureDeviceConfigurationControlPropertyBitVector;
static  CaptureDeviceConfigurationControlPropertyBitVector         property_bit_vector     = (CaptureDeviceConfigurationControlPropertyBitTorchLevel |
                                                                                              CaptureDeviceConfigurationControlPropertyBitLensPosition |
                                                                                              CaptureDeviceConfigurationControlPropertyBitExposureDuration |
                                                                                              CaptureDeviceConfigurationControlPropertyBitISO |
                                                                                              CaptureDeviceConfigurationControlPropertyBitZoomFactor);
static  CaptureDeviceConfigurationControlPropertyBitVector * const property_bit_vector_ptr = &property_bit_vector;

typedef NS_OPTIONS(uint8_t, CaptureDeviceConfigurationControlSelectedPropertyBit) {
    CaptureDeviceConfigurationControlSelectedPropertyBitTorchLevel       = 1 << 0,
    CaptureDeviceConfigurationControlSelectedPropertyBitLensPosition     = 1 << 1,
    CaptureDeviceConfigurationControlSelectedPropertyBitExposureDuration = 1 << 2,
    CaptureDeviceConfigurationControlSelectedPropertyBitISO              = 1 << 3,
    CaptureDeviceConfigurationControlSelectedPropertyBitZoomFactor       = 1 << 4,
};
typedef CaptureDeviceConfigurationControlSelectedPropertyBit               CaptureDeviceConfigurationControlSelectedPropertyBitMask;
typedef CaptureDeviceConfigurationControlSelectedPropertyBitMask           CaptureDeviceConfigurationControlSelectedPropertyBitVector;
static  CaptureDeviceConfigurationControlSelectedPropertyBitVector         selected_property_bit_vector     = (0 << 0 | 0 << 1 | 0 << 2 | 0 << 3 | 0 << 4);
static  CaptureDeviceConfigurationControlSelectedPropertyBitVector * const selected_property_bit_vector_ptr = &selected_property_bit_vector;

typedef NS_OPTIONS(uint8_t, CaptureDeviceConfigurationControlHiddenPropertyBit) {
    CaptureDeviceConfigurationControlHiddenPropertyBitTorchLevel       = 1 << 0,
    CaptureDeviceConfigurationControlHiddenPropertyBitLensPosition     = 1 << 1,
    CaptureDeviceConfigurationControlHiddenPropertyBitExposureDuration = 1 << 2,
    CaptureDeviceConfigurationControlHiddenPropertyBitISO              = 1 << 3,
    CaptureDeviceConfigurationControlHiddenPropertyBitZoomFactor       = 1 << 4,
};
typedef CaptureDeviceConfigurationControlHiddenPropertyBit               CaptureDeviceConfigurationControlHiddenPropertyBitMask;
typedef CaptureDeviceConfigurationControlHiddenPropertyBitMask           CaptureDeviceConfigurationControlHiddenPropertyBitVector;
static  CaptureDeviceConfigurationControlHiddenPropertyBitVector         hidden_property_bit_vector     = (0 << 0 | 0 << 1 | 0 << 2 | 0 << 3 | 0 << 4);
static  CaptureDeviceConfigurationControlHiddenPropertyBitVector * const hidden_property_bit_vector_ptr = &hidden_property_bit_vector;

/* Possible bit masks
 CaptureDeviceConfigurationControlPropertyBit or (CaptureDeviceConfigurationControlPropertyBit | CaptureDeviceConfigurationControlPropertyBit...)
 - mask on the property bit(s) (if not already) while leaving others unchanged
 0b00000
 - returns the property bit vector unchanged
 0b11111
 - masks on all property bits
 */

static CaptureDeviceConfigurationControlPropertyBitVector (^mask_property_bit_vector)(CaptureDeviceConfigurationControlPropertyBitMask) = ^ CaptureDeviceConfigurationControlPropertyBitVector (CaptureDeviceConfigurationControlPropertyBitMask property_bit_mask) {
    property_bit_vector = property_bit_vector | property_bit_mask;
    return *property_bit_vector_ptr;
};

/*
 Possible bit masks
 - CaptureDeviceConfigurationControlSelectedPropertyBit
 - select a new property/deselect old property: mask on the property bit (if not already) while masking off any other selected bit (if any)
 - 0b00000
 - deselect a property
 */

static CaptureDeviceConfigurationControlSelectedPropertyBitVector (^mask_selected_property_bit_vector)(CaptureDeviceConfigurationControlSelectedPropertyBit) = ^ CaptureDeviceConfigurationControlSelectedPropertyBitVector (CaptureDeviceConfigurationControlSelectedPropertyBit selected_property_bit) {
    
    /*    CaptureDeviceConfigurationControlSelectedPropertyBitMask (^selected_property_bit_mask)(CaptureDeviceConfigurationControlSelectedPropertyBitMask mask) {
     //        // pass as a parameter to the hidden bit vector block for a calculation
     //        // execute the return block for the assignment
     //        return (selected_property_bit_vector & selected_property_bit);
     //    };
     */
    selected_property_bit_vector   = selected_property_bit_vector & 0;
    selected_property_bit_vector   = selected_property_bit_vector | selected_property_bit;
    hidden_property_bit_vector    ^= ~((selected_property_bit_vector & ~selected_property_bit_vector));
    /* toggle hidden bit vector ^ using an ~inverted selected bit vector &= ~not the selected bit
     // inverted selected bit vector = (selected_property_bit_vector & = ~selected_property_bit_vector)
     // toggle hidden bits = hidden_property_bit_vector ^
     // exclude selected bit from toggle = ~selected_property_bit_vector */
    return *selected_property_bit_vector_ptr;
};

/*
 Possible bit masks
 - selected_property_bit_vector
 - toggle every hidden bit using an inverted selected bit vector, but not the selected bit
 -
 */

static CaptureDeviceConfigurationControlHiddenPropertyBitVector (^mask_hidden_property_bit_vector)(CaptureDeviceConfigurationControlSelectedPropertyBitVector) = ^ (CaptureDeviceConfigurationControlSelectedPropertyBitMask selected_property_bit_mask) {
    return *hidden_property_bit_vector_ptr;
    /*    hidden_property_bit_vector ^= ~selected_property_bit_mask; // moved temporarily to mask_selected_property_bit_vector
     //
     //    return *hidden_property_bit_vector_ptr; */
};

// Button rendering

#define degreesToRadians(angleDegrees) (angleDegrees * M_PI / 180.0)

typedef NS_OPTIONS(NSUInteger, CaptureDeviceConfigurationControlProperty) {
    CaptureDeviceConfigurationControlPropertyTorchLevel       = 0,
    CaptureDeviceConfigurationControlPropertyLensPosition     = 1,
    CaptureDeviceConfigurationControlPropertyExposureDuration = 2,
    CaptureDeviceConfigurationControlPropertyISO              = 3,
    CaptureDeviceConfigurationControlPropertyZoomFactor       = 4,
    CaptureDeviceConfigurationControlPropertyNone             = 5
};

static NSArray<NSArray<NSString *> *> * const CaptureDeviceConfigurationControlPropertyImageNames = @[@[@"bolt.circle",
                                                                                                        @"viewfinder.circle",
                                                                                                        @"timer",
                                                                                                        @"camera.aperture",
                                                                                                        @"magnifyingglass.circle"],@[@"bolt.circle.fill",
                                                                                                                                     @"viewfinder.circle.fill",
                                                                                                                                     @"timer",
                                                                                                                                     @"camera.aperture",
                                                                                                                                     @"magnifyingglass.circle.fill"]];

static NSArray<NSString *> * const CaptureDeviceConfigurationControlPropertyImageKeys = @[@"CaptureDeviceConfigurationControlPropertyTorchLevel",
                                                                                          @"CaptureDeviceConfigurationControlPropertyLensPosition",
                                                                                          @"CaptureDeviceConfigurationControlPropertyExposureDuration",
                                                                                          @"CaptureDeviceConfigurationControlPropertyISO",
                                                                                          @"CaptureDeviceConfigurationControlPropertyZoomFactor"];

typedef enum : NSUInteger {
    CaptureDeviceConfigurationControlStateDeselected,
    CaptureDeviceConfigurationControlStateSelected,
    CaptureDeviceConfigurationControlStateHighlighted,
    CaptureDeviceConfigurationControlStateAny
} CaptureDeviceConfigurationControlState;

static NSString * (^CaptureDeviceConfigurationControlPropertySymbol)(CaptureDeviceConfigurationControlProperty, CaptureDeviceConfigurationControlState) = ^ NSString * (CaptureDeviceConfigurationControlProperty property, CaptureDeviceConfigurationControlState state) {
    return CaptureDeviceConfigurationControlPropertyImageNames[state][property];
};

static NSString * (^CaptureDeviceConfigurationControlPropertyString)(CaptureDeviceConfigurationControlProperty) = ^ NSString * (CaptureDeviceConfigurationControlProperty property) {
    return CaptureDeviceConfigurationControlPropertyImageKeys[property];
};

// To-Do: Find a different blue that works on a gray background like blueColor, but closer to the non-primary blue of systemBlueColor
static UIImageSymbolConfiguration * (^CaptureDeviceConfigurationControlPropertySymbolImageConfiguration)(CaptureDeviceConfigurationControlState) = ^ UIImageSymbolConfiguration * (CaptureDeviceConfigurationControlState state) {
    switch (state) {
        case CaptureDeviceConfigurationControlStateDeselected: {
            UIImageSymbolConfiguration * symbol_palette_colors = [UIImageSymbolConfiguration configurationWithHierarchicalColor:[UIColor colorWithRed:4/255 green:51/255 blue:255/255 alpha:1.0]];
            UIImageSymbolConfiguration * symbol_font_weight    = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightLight];
            UIImageSymbolConfiguration * symbol_font_size      = [UIImageSymbolConfiguration configurationWithPointSize:42.0 weight:UIImageSymbolWeightUltraLight];
            UIImageSymbolConfiguration * symbol_configuration  = [symbol_font_size configurationByApplyingConfiguration:[symbol_palette_colors configurationByApplyingConfiguration:symbol_font_weight]];
            return symbol_configuration;
        }
            break;
            
        case CaptureDeviceConfigurationControlStateSelected: {
            UIImageSymbolConfiguration * symbol_palette_colors_selected = [UIImageSymbolConfiguration configurationWithHierarchicalColor:[UIColor colorWithRed:255/255 green:252/255 blue:121/255 alpha:1.0]];// configurationWithPaletteColors:@[[UIColor yellowCollor], [UIColor clearColor], [UIColor yellowCollor]]];
            UIImageSymbolConfiguration * symbol_font_weight_selected    = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightRegular];
            UIImageSymbolConfiguration * symbol_font_size_selected      = [UIImageSymbolConfiguration configurationWithPointSize:42.0 weight:UIImageSymbolWeightLight];
            UIImageSymbolConfiguration * symbol_configuration_selected  = [symbol_font_size_selected configurationByApplyingConfiguration:[symbol_palette_colors_selected configurationByApplyingConfiguration:symbol_font_weight_selected]];
            
            return symbol_configuration_selected;
        }
            
        case CaptureDeviceConfigurationControlStateHighlighted: {
            UIImageSymbolConfiguration * symbol_palette_colors_highlighted = [UIImageSymbolConfiguration configurationWithHierarchicalColor:[UIColor colorWithRed:255/255 green:252/255 blue:121/255 alpha:1.0]];// configurationWithPaletteColors:@[[UIColor yellowCollor], [UIColor clearColor], [UIColor yellowCollor]]];
            UIImageSymbolConfiguration * symbol_font_weight_highlighted    = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightRegular];
            UIImageSymbolConfiguration * symbol_font_size_highlighted      = [UIImageSymbolConfiguration configurationWithPointSize:84.0 weight:UIImageSymbolWeightLight];
            UIImageSymbolConfiguration * symbol_configuration_highlighted  = [symbol_font_size_highlighted configurationByApplyingConfiguration:[symbol_palette_colors_highlighted configurationByApplyingConfiguration:symbol_font_weight_highlighted]];
            
            return symbol_configuration_highlighted;
        }
            break;
        default:
            return nil;
            break;
    }
};

static UIImage * (^CaptureDeviceConfigurationControlPropertySymbolImage)(CaptureDeviceConfigurationControlProperty, CaptureDeviceConfigurationControlState) = ^ UIImage * (CaptureDeviceConfigurationControlProperty property, CaptureDeviceConfigurationControlState state) {
    return [UIImage systemImageNamed:CaptureDeviceConfigurationControlPropertySymbol(property, state) withConfiguration:CaptureDeviceConfigurationControlPropertySymbolImageConfiguration(state)];
};


static inline uint8_t rotl8 (uint8_t n, unsigned int c)
{
  const unsigned int mask = (CHAR_BIT*sizeof(n) - 1);  // assumes width is a power of 2.

  // assert ( (c<=mask) &&"rotate by type width or more");
  c &= mask;
  return (n<<c) | (n>>( (-c)&mask ));
}

static inline uint32_t rotr32 (uint32_t n, unsigned int c)
{
  const unsigned int mask = (CHAR_BIT*sizeof(n) - 1);

  // assert ( (c<=mask) &&"rotate by type width or more");
  c &= mask;
  return (n>>c) | (n<<( (-c)&mask ));
}

int conditional(int x, int y, int z) {
  return ((((!x)<<31)>>31) & z) + ((((!(!x))<<31)>>31) & y);
}

uint8_t mask[8] = {1 << 0, 1 << 1, 1 << 2, 1 << 3, 1 << 4, 1 << 5};

int getByte(int x, int n) {
  return (x >> (n<<5)) & 0xff;
}

static void (^print_byte)(CaptureDeviceConfigurationControlPropertyBitVector, CaptureDeviceConfigurationControlPropertyBit) = ^ (CaptureDeviceConfigurationControlPropertyBitVector bit_vector, CaptureDeviceConfigurationControlPropertyBit bit) {
    
    printf("\n\t%d\n", ((BOOL)(getByte(bit_vector, bit) & mask[bit]) ? 1 : 0));
};


static const UIButton * (^buttons[5])(void);
static const UIButton * (^(^(^button_group)(CaptureDeviceConfigurationControlPropertyBitMask, CaptureDeviceConfigurationControlSelectedPropertyBitMask, CaptureDeviceConfigurationControlHiddenPropertyBitMask))(CaptureDeviceConfigurationControlProperty))(void) =  ^ (CaptureDeviceConfigurationControlPropertyBitMask property_bit_mask, CaptureDeviceConfigurationControlSelectedPropertyBitMask selected_property_bit_mask, CaptureDeviceConfigurationControlHiddenPropertyBitMask hidden_property_bit_mask) {
    for (unsigned int property_tag = 0; property_bit_vector; property_bit_vector >>= 1) {
        __block UIButton * (^button)(void);
        button = ^{
            UIButton * button;
            [button = [UIButton new] setTag:property_tag];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setImage:[UIImage systemImageNamed:CaptureDeviceConfigurationControlPropertyImageNames[0][property_tag] withConfiguration:CaptureDeviceConfigurationControlPropertySymbolImageConfiguration(CaptureDeviceConfigurationControlStateDeselected)] forState:UIControlStateNormal];
            [button setImage:[UIImage systemImageNamed:CaptureDeviceConfigurationControlPropertyImageNames[1][property_tag] withConfiguration:CaptureDeviceConfigurationControlPropertySymbolImageConfiguration(CaptureDeviceConfigurationControlStateSelected)] forState:UIControlStateSelected];
            [button setTitle:[NSString stringWithFormat:@"%d - %d",
                              (BOOL)(getByte(selected_property_bit_vector, property_tag) & mask[property_tag]), //(selected_property_bit_vector | (CaptureDeviceConfigurationControlSelectedPropertyBit)(property_tag)),
                              (BOOL)(getByte(hidden_property_bit_vector,   property_tag) & mask[property_tag])] forState:UIControlStateNormal];
            [button sizeToFit];
            [[button titleLabel] setAdjustsFontSizeToFitWidth:CGRectGetWidth([[button titleLabel] frame])];

            [button setUserInteractionEnabled:TRUE];
            
            void (^eventHandlerBlock)(void) = ^{
                printf("\n\n%d-----------%d-------------%d\n", property_tag, property_tag, property_tag);
                print_byte(selected_property_bit_vector, buttons[property_tag]().tag);
                selected_property_bit_vector &= ~(selected_property_bit_vector);
                print_byte(selected_property_bit_vector, buttons[property_tag]().tag);
                selected_property_bit_vector |= mask[property_tag];
                print_byte(selected_property_bit_vector, buttons[property_tag]().tag);
                printf("\n%d-----------%d-------------%d\n\n", property_tag, property_tag, property_tag);
                hidden_property_bit_vector ^= ~((selected_property_bit_vector & getByte(selected_property_bit_vector, property_tag)));
                for (int property = 0; property < 5; property++) {
                    [buttons[property]() setTitle:[NSString stringWithFormat:@"%d - %d",
                                                   (BOOL)(getByte(selected_property_bit_vector, property_tag) & mask[buttons[property]().tag]), //(selected_property_bit_vector | (CaptureDeviceConfigurationControlSelectedPropertyBit)(property_tag)),
                                                   (BOOL)(getByte(hidden_property_bit_vector,   property_tag) & mask[buttons[property]().tag])] forState:UIControlStateNormal];
                    [buttons[property]() setSelected:(BOOL)(getByte(selected_property_bit_vector, property_tag) & mask[buttons[property]().tag])]; //(selected_property_bit_vector | (CaptureDeviceConfigurationControlSelectedPropertyBit)(property_tag)),
                     
//                    [buttons[property]() setHidden:(BOOL)(getByte(selected_property_bit_vector, property_tag) & mask[buttons[property]().tag]) &
//                                                   (BOOL)!(getByte(hidden_property_bit_vector, property_tag) & mask[buttons[property]().tag])];

                };
            };
            objc_setAssociatedObject(button, @selector(invoke), eventHandlerBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [button addTarget:eventHandlerBlock action:@selector(invoke) forControlEvents:UIControlEventTouchUpInside];
            
            return ^ UIButton * (void) {
                [button setSelected:(BOOL)(getByte(selected_property_bit_vector, property_tag) & mask[button.tag])]; //(selected_property_bit_vector | (CaptureDeviceConfigurationControlSelectedPropertyBit)(property_tag)),
                    [button setHidden:(BOOL)(getByte(hidden_property_bit_vector, property_tag) & mask[button.tag])];
                return button;
            };
        }();
        buttons[property_tag] = button;
        property_tag += property_bit_vector & 1;
        
    }
    
    return ^ (CaptureDeviceConfigurationControlProperty property_index) {
        return buttons[property_index];
    };
};
static UIButton * (^(^property_button)(CaptureDeviceConfigurationControlProperty))(void);



@interface ViewController ()

@end

@implementation ViewController

/**
 Multiplication
 按位 与 & 运算 :
 1 & 1 = 1
 1 & 0 = 0
 0 & 0 = 0
 总结规则:有0则为0 即:一假则假
 
 Boolean Algebra
 按位 或 | 运算:
 1 | 1 = 1
 1 | 0 = 1
 0 | 0 = 0
 总结规则: 有1则为1   即:一真则真
 https://www.jianshu.com/p/9810944d6d47
 */
//static uint8_t property_bit_vector_[5][3];

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    print_debug("Reading property_bit_vector...");
    //    for (unsigned int property_tag = 0; property_bit_vector; property_bit_vector >>= 1) {
    //        print_debug("property_tag");
    //        property_tag += property_bit_vector & 1;
    //    }
    
    //    unsigned int c; // c accumulates the total bits set in v
    //    for (c = 0; property_bit_vector; c++)
    //    {
    //        //        if (((property_bit_vector >> bit_set_count) & 1) != 0) {
    //        printf("%d\t\t\t%d\n-------------\n\n", c, (int)(property_bit_vector));
    //        property_bit_vector &= property_bit_vector - 1; // clear the least significant bit set
    //    }
    
    //    CaptureDeviceConfigurationControlPropertyBitVector property_bit_vector_temp = property_bit_vector;
    //    for (unsigned int bit_set_count = 0; property_bit_vector_temp; property_bit_vector_temp >>= 1) {
    //        if (((property_bit_vector >> bit_set_count) & 1) != 0) {
    //            printf("FOUND\t\t%d\t\t\t%d\n-------------\n\n", bit_set_count, (int)(property_bit_vector_temp));
    //        } else {
    //            printf("NOT FOUND\t\t%d\t\t\t%d\n-------------\n\n", bit_set_count, (int)(property_bit_vector_temp));
    //        }
    ////        printf("%d\t\t\t%d\n-------------\n\n", bit_set_count, (int)(property_bit_vector_temp));
    //        bit_set_count += property_bit_vector_temp & 1;
    //
    //    }
    
    UIButton * (^(^bg)(CaptureDeviceConfigurationControlProperty))(void) = button_group(property_bit_vector, selected_property_bit_vector, hidden_property_bit_vector);
    for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertyNone; property++) {
        [self.view addSubview:bg(property)()];
        [bg(property)() setCenter:CGPointMake(CGRectGetMidX(bg(property)().superview.frame), CGRectGetMidY(bg(property)().superview.frame) + (bg(property)().frame.size.height + bg(property)().intrinsicContentSize.height) * property)];
    }
}




#define BITMASK(b) (1 << ((b) % CHAR_BIT))
#define BITSLOT(b) ((b) / CHAR_BIT)
#define BITSET(a, b) ((a)[BITSLOT(b)] |= BITMASK(b))
#define BITCLEAR(a, b) ((a)[BITSLOT(b)] &= ~BITMASK(b))
#define BITTEST(a, b) ((a)[BITSLOT(b)] & BITMASK(b))
#define BITNSLOTS(nb) ((nb + CHAR_BIT - 1) / CHAR_BIT)




@end

//    for (unsigned int bit_set_count = 0; property_bit_vector; property_bit_vector >>= 1) {
//        bit_set_count += property_bit_vector & 1;
//        buttons[bit_set_count] = ^ (unsigned int property_tag) {
//            UIButton * button;
//            [button = [UIButton new] setTag:property_tag];
//            [button setBackgroundColor:[UIColor clearColor]];
//            [button setImage:[UIImage systemImageNamed:CaptureDeviceConfigurationControlPropertyImageNames[0][property_tag] withConfiguration:CaptureDeviceConfigurationControlPropertySymbolImageConfiguration(CaptureDeviceConfigurationControlStateDeselected)] forState:UIControlStateNormal];
//            [button setImage:[UIImage systemImageNamed:CaptureDeviceConfigurationControlPropertyImageNames[1][property_tag] withConfiguration:CaptureDeviceConfigurationControlPropertySymbolImageConfiguration(CaptureDeviceConfigurationControlStateSelected)] forState:UIControlStateSelected];
//            [button sizeToFit];
//            [button setUserInteractionEnabled:FALSE];
//
//            void (^eventHandlerBlock)(void) = ^{ };
//            objc_setAssociatedObject(button, @selector(invoke), eventHandlerBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//            [button addTarget:eventHandlerBlock action:@selector(invoke) forControlEvents:UIControlEventTouchUpInside];
//
//            return ^ UIButton * (void) {
//                return button;
//            };
//
//        }(bit_set_count);
//    }
