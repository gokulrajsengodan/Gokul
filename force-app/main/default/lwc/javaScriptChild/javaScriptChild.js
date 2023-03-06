const si =(p ,t , r) => {
		if(p && t && r){
				const sit=(p * t * r)/100;
				return sit;
		}
		return 0;
}
export{ si }