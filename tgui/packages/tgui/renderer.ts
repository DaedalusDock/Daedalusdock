import { perf } from 'common/perf';
import { ReactNode } from 'react';
import { createLogger } from './logging';
import { createRoot, Root } from 'react-dom/client';

const logger = createLogger('renderer');

let reactRoot: Root;
let initialRender: string | boolean = true;
let suspended = false;

// These functions are used purely for profiling.
export const resumeRenderer = () => {
  initialRender = initialRender || 'resumed';
  suspended = false;
};

export const suspendRenderer = () => {
  suspended = true;
};

type CreateRenderer = <T extends unknown[] = [unknown]>(
  getVNode?: (...args: T) => ReactNode,
) => (...args: T) => void;

export const createRenderer: CreateRenderer =
  (getVNode) =>
  (...args) => {
    perf.mark('render/start');
    // Start rendering
    if (!reactRoot) {
      const element = document.getElementById('react-root');
      reactRoot = createRoot(element!);
    }
    if (getVNode) {
      reactRoot.render(getVNode(...args));
    } else {
      reactRoot.render(args[0] as any);
    }
    perf.mark('render/finish');
    if (suspended) {
      return;
    }
    // Report rendering time
    if (process.env.NODE_ENV !== 'production') {
      if (initialRender === 'resumed') {
        logger.log(
          'rendered in',
          perf.measure('render/start', 'render/finish'),
        );
      } else if (initialRender) {
        logger.debug('serving from:', location.href);
        logger.debug('bundle entered in', perf.measure('inception', 'init'));
        logger.debug('initialized in', perf.measure('init', 'render/start'));
        logger.log(
          'rendered in',
          perf.measure('render/start', 'render/finish'),
        );
        logger.log(
          'fully loaded in',
          perf.measure('inception', 'render/finish'),
        );
      } else {
        logger.debug(
          'rendered in',
          perf.measure('render/start', 'render/finish'),
        );
      }
    }
    if (initialRender) {
      initialRender = false;
    }
  };
