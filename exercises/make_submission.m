% BUILD THE REQUIRED .MLX AND .PDF IN MATLAB (run in the Command Window).
% Copy the entire exercises folder to your computer. Open MATLAB, set
% the current folder to exercises, then run:  make_submission
%
% NOTE: This helper cannot be run without MATLAB and Image Processing Toolbox.
% Save the .mlx again AFTER running it in the Live Editor so the six sections'
% outputs are embedded in the file, as required by the coursework.
base = fileparts(mfilename('fullpath'));
source = fullfile(base,'exercises.m');
target = fullfile(base,'exercises.mlx');
pdfTarget = fullfile(base,'exercises.pdf');
assert(exist(source,'file')==2,'Missing exercises.m');
assert(~isempty(ver('images')),'Image Processing Toolbox is required.');
% Convert the ordinary MATLAB script into a binary live script.
% openAsLiveCode is a MATLAB internal editor helper; an interactive
% fallback is given in README.md if a MATLAB release does not support it.
if exist(target,'file') ~= 2
    matlab.internal.liveeditor.openAsLiveCode(fileread(source));
    liveDocument = matlab.desktop.editor.getActive();
    liveDocument.saveAs(target);
    disp(['Created: ' target]);
else
    disp(['Using existing live script: ' target]);
end
% Run the Live Script and export the executed code plus results to PDF.
% Run=true must be invoked from the MATLAB Command Window, not the Live Editor.
export(target,pdfTarget,'Run',true,'CatchError',false,'PageSize','A4');
disp(['Created: ' pdfTarget]);
disp('IMPORTANT: open exercises.mlx, Run All, then Ctrl+S before GitHub upload.');
