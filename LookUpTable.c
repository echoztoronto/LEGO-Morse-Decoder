char LookUpTable (unsigned code) {
	while (!(code & 1)) { //Remove all 0's from LSB
		code = code >> 1;
	}
	switch (code) {
		case 23:	//1 0111
			return a;
			break;
		case 469:	//1 1101 0101
			return b;
			break;
		case 1885:	//111 0101 1101
			return c;
			break;
		case 117:	//111 0101
			return d;
			break;
		case 1:		//1
			return e;
			break;
		case 349:	//1 0101 1101
			return f;
			break;
		case 477:	//1 1101 1101
			return g;
			break;
		case 85:	//101 0101
			return h;
			break;
		case 5:		//101
			return i;
			break;
		case 6007:	//1 0111 0111 0111
			return j;
			break;
		case 471:	//1 1101 0111
			return k;
			break;
		case 373:	//1 0111 0101
			return l;
			break;
		case 119:	//111 0111
			return m;
			break;
		case 29:	//1 1101
			return n;
			break;
		case 1911:	//111 0111 0111
			return o;
			break;
		case 1501:	//101 1101 1101
			return p;
			break;
		case 7639:	//1 1101 1101 0111
			return q;
			break;
		case 93:	//101 1101
			return r;
			break;
		case 21:	//1 0101
			return s;
			break;
		case 7:		//111
			return t;
			break;
		case 87:	//101 0111
			return u;
			break;
		case 343:	//1 0101 0111
			return v;
			break;
		case 375:	//1 0111 0111
			return w;
			break;
		case 1879:	//111 0101 0111
			return x;
			break;
		case 7543:	//1 1101 0111 0111
			return y;
			break;
		case 1909:	//111 0111 0101
			return z;
			break;
		default:
			return 0;
	}
}