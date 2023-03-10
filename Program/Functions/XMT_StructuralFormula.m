function [MatrixSF,ElementsList] = XMT_StructuralFormula(MatrixOxide,OxList,OxBasis)
%

[ListOx,ListEl,NbEl,NbOx,MolarW] = XMF_StructuralFormulaDefinitions(1);

if ~iscell(OxList)
    Ox = strread(OxList,'%s');
else
    Ox = OxList;
end

[lia,loc] = ismember(Ox,ListOx);

NbCalc = size(MatrixOxide,1);
NbElem = size(MatrixOxide,2);

Num = repmat(NbEl(loc),NbCalc,1);
NumO = repmat(NbOx(loc),NbCalc,1);
Cst = repmat(MolarW(loc),NbCalc,1);

AtomicPer = MatrixOxide./Cst.*Num;

TheSum = sum((AtomicPer .* NumO) ./ Num,2);
RefOx = repmat(TheSum/OxBasis,1,NbElem);

MatrixSF = AtomicPer ./ RefOx;

ElementsList = ListEl(loc);

return