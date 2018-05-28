// sin(x) = x - x^3 / 3! + x^5 / 5! - x^7 / 7! ... - x^15 / 15! + x^17 / 17!
float my_sinf( float x )
{
	float x2 = x * x ;
	float x3 = x * x2 ;
	x -= x3 * (float)(1.0/6.0 ) ;
	float x5 = x3 * x2 ;
	x += x5 * (float)(1.0/120.0 ) ;
	float x7 = x5 * x2 ;
	x -= x7 * (float)(1.0/5040.0 ) ;
	float x9 = x7 * x2 ;
	x += x9  * (float)(1.0/362880.0 ) ;
	float x11 = x9 * x2 ;
	x -= x11 * (float)(1.0/39916800.0 ) ;
	float x13 = x11 * x2 ;
	x += x13 * (float)(1.0/6227020800.0 ) ;
	float x15 = x13 * x2 ;
	x -= x15 * (float)(1.0/1307674368000.0 ) ;
	float x17 = x15 * x2 ;
	x += x17 * (float)(1.0/355687428096000.0 ) ;

	return x ;
} ;
